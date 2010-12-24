#!/usr/bin/perl
#     ##############################################################################
#    #                                                                            ##
#   ############################################################################## #
#   #                                                                            # #
#   #                                 sb2make.pl                                 # #
#   #                                V 0.9.9                                     # #
#   #                             12/24/2010 2005                                # #
#   #                                                                            ##
#   ##############################################################################
##  Description: 
##  TWW HPMS use xml language describe it package source.
##  Currently there is no makefile to automate the building of TWW packages.
##  sb2make.pl script use perl language that utilize XML::XPath module to generate Makefiles
##  from parsing TWW package xml source to find out the dependency and use Graph to data structure
##  represent the package dependency.
#
##  XML::XPath to generate Makefiles from parsing XML files in zipped .sb(sb-db.xml) and .pb XML formats.
##     
##  Idea copied from src2make.pl in openpkg project(http://www.openpkg.org).
##
##  Permission to use, copy, modify, and distribute this software for
##  any purpose with or without fee is hereby granted, provided that
##  the above copyright notice and this permission notice appear in all
##  copies.
##
##  THIS SOFTWARE IS PROVIDED ``AS IS'' AND ANY EXPRESSED OR IMPLIED
##  WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
##  MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
##  IN NO EVENT SHALL THE AUTHORS AND COPYRIGHT HOLDERS AND THEIR
##  CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
##  SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
##  LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF
##  USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
##  ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
##  OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT
##  OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
##  SUCH DAMAGE.
##  Discription:
##   0. TWW package dependcy graph: a math graph which describe the 
##          dependency relationship among TWW packages.
## 
##   1. root node: a package in a TWW package dependcy graph which rely
##                 on no other packages to be build/install first.
##   2. 02/27/2003: create .pkg-inst .pkg-inst.md5 and upload them 
##        to apps.comm.mot.com
##   3. 05/18/2003: finding basic dependency
##   4. 01/09/2004: changed to gmake syntax 
##  Done:
##   1. Root packages can new be compiled and builded.
##   2. 
##  TODO: 
##   1. Need to get the dependcy graph
##   2. read in and prune the xml tree to only needed nodes/elements
##      parsing same sb-db.xml and pb-db.xml 4 times is very embarrassed.
#    3. more processing of content of a sb-db.xml
#    4. moudule=default module=tww-static, module=64bit
#    5. Too much disk io ! Need to rewrite this to read all the sb and pb files
#       into memory(building trees). 
##  References;
##  1. Perl cookbook
##     borrow the algorithem for finding arry union,difference and intersect.
##  2. Perl & XML
#      XML::XPath processing very  needed for processing XML.
##  3. Mastering Algorithms with Perl
##     Chapther 8 Graph: a perfect fit to solve our problem here.
#      Building TWW graph rely on the Graph modules.
##  4. http://www.thewrittenword.com
##  5. Managing Projects With make. 
#      

#     ##############################################################################
#    #                                                                            ##
#   ############################################################################## #
#   #                                                                            # #
#   #   Perl Modules                                                             # #
#   #                                                                            ##
#   ##############################################################################

#use strict;
use lib './lib';
use Getopt::Long;
use IO;
use Data::Dumper;
use XML::LibXML;
use XML::XPath;
use Graph;
use GraphViz;
use TWW;
use Makefile;
use Help;
#     ##############################################################################
#    #                                                                            ##
#   ############################################################################## #
#   #                                                                            # #
#   #   Variables                                                                # #
#   #                                                                            ##
#   ##############################################################################


my $progvers = "0.9.0";
my $progname = "sb2make.pl";
$Data::Dumper::Indent = 1;
$Data::Dumper::Purity = 1;
my $verbose = 0;
my $quiet   = 0;
my $help    = 0;
my $debug   = 0;

my $user        = "";
my $group       = "";
my $tmpdir      = ($ENV{TMPDIR} || $ENV{TEMPDIR} || "/tmp") . "/tww";

my $nouninstall = 0;
my $package_install_name="test1";
my $package_pkgname_base="test2";
my $package_version="test3";
my $package_revision="test4";

my $hdr2;
my $ARCHI;
my $EXTRACT;
my $buildsrc;
my $install;
my @SBSRC;
my $srcdir=".";


my $BPFX=$build_prefix; 
my $DISTPFX=$dist_prefix;


my @cleanup = ();
my   %program  = (
        prefix          => "/opt/TWW",
        iinstall_prefix => "/opt/TWW",
        install_prefix  => "\$\{SBFX\}",
        install_record  => "\$\{SBRD\}",
        bbuild_prefix   => "\$\{BPFX\}",
        build_prefix    => "\$\{BPFX\}",
        ddist_prefix    => "/opt/dist/cd",
        dist_prefix     => "\$\{DISTPFX\}",
        BSB             => "/opt/TWWfsw/bin/sb",
        BPB             => "/opt/TWWfsw/bin/pb",
        DISTNAME        => "TWW",
        bbuild_prefix   => "/opt/build",
        srcdir          => '.',
        outdir          => '.'
    );


#     ##############################################################################
#    #                                                                            ##
#   ############################################################################## #
#   #                                                                            # #
#   #   Main Program                                                             # #
#   #                                                                            ##
#   ##############################################################################



#   command line parsing
Getopt::Long::Configure("bundling");
my $result = GetOptions(
    'h|help'        => \$help,
    'q|quiet'       => \$quiet,
    'v|verbose'     => \$verbose,
    'd|debug'       => \$debug,
    'p|prefix=s'    => \$prefix,
    'b|prefix=s'    => \$buildsrc,
    'i|install=s'   => \$install,
    's|srcdir=s'    => \$srcdir,
    'o|outdir=s'    => \$outdir,
    'a|arch=s'      => \$ARCHI,
    'e|extract'   => \$EXTRACT,
    'g|graph'     => \$graph
);



# specify installation path, dist name


$program{outdir} = $program{srcdir} if ($program{outdir} eq '');

if ($program{prefix} eq '' or $program{srcdir} eq '') {
    die "at least --prefix and --srcdir have to be specified";
}


if (not (-x $program{BSB} and -x $program{BPB} )) {
    die "programs 'sb' and 'pb' not found under TWW HPMS hierarchy '$prefix'";
}

my $sb;
if (($sb = TWW::fullpath("sb")) eq '') {
    die "program 'sb' not found in PATH";
}
if (not -d $tmpdir) {
    mkdir($tmpdir, 0700) || die "cannot create temporary directory '$tmpdir'";
    &cleanup_remember("rm -rf $tmpdir");
}

#
#   scan source directory for Source sb file  and build dependency graphs
#   pattern=  pkgname-version.sb
#   Examples: zsh-4.0.4.sb
#             
#
my @SBDG ;    # an array for sb depended graph
my $PGV = {}; # provides-graph for virtual packages
my $DGB = {}; # dependency-graph for building
my $DGI = {}; # dependency-graph for installing
my $PMV = {}; # package maximum/latest version
my @isect_nodes;    # independed packages
my @isect_nodes_install_name;                 # independed packages
my @SBSRC_no_ext; # .sb are taken out
my @PBSRC_no_ext; # .pb are taken out

my $tww_sb_graph = Graph -> new;
my $tww_graphviz = GraphViz -> new(width => 10, height => 20);
my $MF_LINE='';
#my $os;
my $PERL_MODULE_LINE='';

my $MF1= '';  # Makefile test content
   
     #find out ARCH type
     # can be subroutine
     $ARCHI= `/opt/TWWfsw/pkgutils15/lib/systype`; 
     #  Delcare some platform specifice variables here
     chomp($ARCHI);
     if($ARCHI eq "sparc-sun-solaris2.6" or $ARCHI eq "sparc-sun-solaris2.8" or $ARCHI eq "sparc-sun-solaris2.9"){     
     $dist_prefix   = "\$\{DISTPFX\}";
     $os=solaris;
     } elsif ($ARCHI eq "hppa1.1-hp-hpux10.20" or $ARCHI eq "hppa1.1-hp-hpux11.11"){
     $dist_prefix   = "\$\{DISTPFX\}";
     $os=hp-ux;
     } elsif ($ARCHI eq "i686-pc-linux-gnu"){
     $dist_prefix   = "\$\{DISTPFX\}/i386";
     $os=rhlinux;
     } elsif ($ARCHI eq "i686-redhat-linux9"){
     $dist_prefix   = "\$\{DISTPFX\}/i386";
     $os=rhlinux;
     }

# What: find_sb
# What: Use @SBSRC and @SBSRC_no_ext arrays to store avaiable package sb files 
#       TWW dist 7.1 syntax
# 
@SBSRC = sort(glob("$srcdir/*/sb-db.xml"));
foreach my $sb (@SBSRC) {
    #before: ./xpm-3.4k/sb-db.xml
    #Assign sb to $_ for s/\.sb// type of inline replacing perl syntax.
    $_ = $sb;
    s/\.\///;
    s/\/sb-db\.xml//;
    # after: xpm-3.4k
    push(@SBSRC_no_ext,$_);
}

# What: find_pb  
# What: Use @PBSRC and @PBSRC_no_ext arrays to store pb package files 
#       TWW dist 7.1 syntax   

my @PBSRC = sort(glob("$srcdir/*/pb-db.xml"));

foreach my $pb (@PBSRC) {
    $_ = $pb;
    s/\.\///;
    s/\/pb-db\.xml//;
    push(@PBSRC_no_ext,$_);
}

Help::verbose(sprintf("packages found: %s\n\n", @PBSRC));

@union = @isect = @diff =();
%union = %isect = ();
%count = ();
#
# What: finding the intersection,union and difference of two arrays.
#       to locate packages that have both sb and pb files.
#      @union:
#      @isect: package have both sb and pb file
#      @diff:
# following code borrow from "Perl CookBook" page
#
foreach $e(@SBSRC_no_ext,@PBSRC_no_ext){$count{$e}++}
foreach $e (keys %count){
    push (@union,$e);
    if ($count{$e} == 2) {
        push @isect,$e;
    }else { 
	push @diff,$e;
    }
}

# The intersection of SBSRC_no_ext and PBSRC_no_ext are the packages with both sb and pb files.
#
# $#SRC+1 = the length of @SBSRC which the number sb files.

# print statstics.
Help::verbose(sprintf("found %d  sb package source files under %s", $#SBSRC+1, $srcdir));
Help::verbose(sprintf("found %d  pb package source files under %s", $#PBSRC+1, $srcdir));
Help::verbose(sprintf("found %d  packages  under %s with both sb and pb files.", $#isect+1, $srcdir));

    if ($EXTRACT) { TWW::extract(@union)};
    if ($graph)   { TWW::AddGraph();};


ISECT_PKG: foreach my $lnode (sort(@isect)) {
    my $sbdbxml = "$srcdir/$lnode/sb-db.xml";  #sb-db.xml file
    Help::verbose("0. Scanning $srcdir/$lnode/sb-db.xml  to find  build information.");
    my $sb_fh = XML::XPath->new(filename=>$sbdbxml);
    my $install_name = $sb_fh->findvalue('/programs/program[1]/@name');
    my $sources_name = $sb_fh->findvalue('/programs/program/sources[1]');
    push(@isect_nodes,$lnode);
    $sb_fh -> cleanup();
 }# ending of ISECT_PKG: foreach my $lnode (sort(@isect)) {

@isect_nodes =reverse(@isect_nodes);
#this section of code deal with packages with only sb files.
Help::verbose(sprintf("The complete vertices in tww_sb_graph before adding dependency: $tww_sb_graph\n"));


#########################################################################
#     Generate Graph into png or jpeg files
#########################################################################

     if ($graph) { TWW::GenGraph()};
     if ($help)  { TWW::help();};
#########################################################################
# Generate  Makefiles
#########################################################################
     &GenMakefile_OS_Common();
     Makefile::GenMakefilePerlModules();
     Makefile::GenMakefileCommon();
     Makefile::GenMakefile(%program);
     exit(0);


#     ##############################################################################
#    #                                                                            ##
#   ############################################################################## #
#   #                                                                            # #
#   #   GenMakefile_OS_Common                                                    # #
#   #                                                                            ##
#   ##############################################################################
#
sub GenMakefile_OS_Common{

    @OSS = ("rhlinux","solaris","hp-ux");
    foreach $OSP (@OSS){
    $dist_prefix="\$\{DISTPFX\}";
    if ( $OSP eq "rhlinux"){$dist_prefix="\$\{DISTPFX\}/i386";}

    my $MF_LINE='';
    $MF_LINE .= Makefile::hdr("Makefile for TWW HPMS packages building, packaging and uploading to apps.comm.mot.com.");
    $MF_LINE .= "allpkgs: "; foreach my $lnode (sort(@isect_nodes)) {$MF_LINE .= "$lnode "; } $MF_LINE .= "\n\n";
    $MF_LINE .= "gen-pkg-inst: "; foreach my $lnode (sort(@isect_nodes)) {$MF_LINE .= "$lnode-gen-pkg-inst "; } $MF_LINE .= "\n\n";
    $MF_LINE .= "upload-all: \n";      
    $MF_LINE .= "\t \$\{RSYNC\} $dist_prefix/*pkg-inst*  root\@apps.comm.mot.com:/export/dist/cd/\$\{ARCHI\}/ \n";
    $MF_LINE .= "upload: "; foreach my $lnode (sort(@isect_nodes)) {$MF_LINE .= "$lnode-upload "; } $MF_LINE .= "\n\n";
    $MF_LINE .= "allsb: "; foreach my $node (sort(@SBSRC_no_ext)) {$MF_LINE .= "$node "; } $MF_LINE .= "\n\n";

 
#####################################################################################################
# Processing packages with sb source only 
#####################################################################################################
my $i=0;
my $total_sb=$#diff+1;

DIFF_PKG: foreach my $lnode (sort(@diff)) {

    $i++;
    $tww_sb_graph->add_vertex($lnode);

    Help::verbose("1. Scanning $srcdir/$lnode/sb-db.xml file to find software build information.");

    my $sbdbxml = "$srcdir/$lnode/sb-db.xml";
    my $sb_fh = XML::XPath->new(filename=>$sbdbxml);
 
    $MF_LINE .= "############################################################################\n";
    $MF_LINE .= "#  $i / $total_sb sb package\n";
    #page 55,perl &XML, p XML::XPath::XMLParser::as_string($depended_nodeset->get_nodelist)
    #     <depend progname="binutils" module="gcc-3.2.2" state="installed">v==2.12.1</depend>
    #     <program name="perl" version="5.6.1" revision="3">
    my $program_name = $sb_fh->find("/programs/program/\@name");
    my $program_version = $sb_fh->find("/programs/program/\@version");
    my $program_revision  = $sb_fh->find("/programs/program/\@revision");

# dist 7.1
#    <dependencies>
#      <depend program="texinfo" add-path="prepend"
#        type="build">v==4.7</depend>
#    </dependencies>
    my $depended_nodeset  = $sb_fh->find('/programs/program/dependencies/depend/@program');
    my $depended_install_name = ""; 

    # making out the full depended_install_name;


# see /opt/TWWfsw/perl580p/lib/5.8.0/XML/XPath/XMLParser.pm
#   print "    Found depended packages: /opt/TWWfsw/", XML::XPath::XMLParser::as_string($node),"\n";
#   Help::verbose("    Found depended packages: /opt/TWWfsw/", XML::XPath::XMLParser::as_string($node),"\n");
# dist 5.1 old syntax
    # findout depended package information from gcc-3.2.2 like pakcages.
    # <depend progname="binutils" module="gcc-3.2.2" state="installed">v==2.12.1</depend>
    # <depend var="TEXINFO" add-path="prepend">texinfo43</depend>

    foreach my $node ($depended_nodeset->get_nodelist){

    my $x= XML::XPath::XMLParser::as_string($node);
    if ( $x ne "perl5005" and  $x ne "perl560" and  $x !~ /^v==.*/ )
    { 
         $depended_install_name .= " $program{install_prefix}/";
         $depended_install_name .= XML::XPath::XMLParser::as_string($node); 
     } elsif ($x =~ /^v==/)
     { 
         $x =~ s|^v==||s; 
      my $p =  $sb_fh->find("/programs/program/module[1]/dependencies/depend/\@progname");    

     $depended_install_name .= $p;
     $depended_install_name .= "-";
     $depended_install_name .= $x;
     }else
     {
     $PERL_MODULE_LINE .=" $lnode ";
     $depended_install_name .= " ";  
     }
    } #end of  foreach my $node ($depended_nodeset->get_nodelist)
  

     Help::verbose("    depended_install_name:  $depended_install_name");   
                                                 # use \ to wrap the line
     $MF_LINE .= "$lnode: $depended_install_name \\\n";  
      my $module_nodeset  = $sb_fh->find('/programs/program/module/@name');

      foreach my $node ($module_nodeset->get_nodelist){
      my $module_name = XML::XPath::XMLParser::as_string($node);
      $module_name =~ s|^ name="||s;
      $module_name =~ s|"||s;
      # ignore perl 5.005.03 and perl 5.6.0 
      if ($module_name ne "5.005_03" and  $module_name ne "5.6.0")  { 
       my $sb_install_name = $sb_fh->find("/programs/program/module[\@name='$module_name']/install-name");
       $MF_LINE .= "$program{install_prefix}/$sb_install_name-$module_name-$lnode ";
      }
      $sb_fh -> cleanup();
      } #end of  foreach my $node ($module_nodeset->get_nodelist){



     $MF_LINE .= "\n#############################################################################\n";

      # build the static modules in a sb-db.xml file
      my $module_nodeset  = $sb_fh->find('/programs/program/module/@name');
 
      foreach my $node ($module_nodeset->get_nodelist){

      my $module_name = XML::XPath::XMLParser::as_string($node);
      $module_name =~ s|^ name="||s;
      $module_name =~ s|"||s;
      my $sb_install_name = $sb_fh->find("/programs/program/module[\@name=\"$module_name\"]/install-name");
  
     if ($module_name ne "5.005_03" and  $module_name ne "5.6.0")  { 
      $MF_LINE .= "$program{install_prefix}/$sb_install_name-$module_name-$lnode:\n";
      Help::verbose("               module_name: $module_name");
      $MF_LINE .= "\t\$\{SB\} -m $module_name \$\{SRCDIR\}/$lnode/sb-db.xml\n";
      $MF_LINE .= "\t\$\{SB\} -m $module_name -i \$\{SRCDIR\}/$lnode/sb-db.xml\n\n";
      }


     $sb_fh -> cleanup();
    } #end of  foreach my $node ($module_nodeset->get_nodelist){
}

#####################################################################################################
# Processing packages with both sb and pb  source.
#####################################################################################################
$x=0;
$total_sb_pb=$#isect+1;
 foreach my $lnode (sort(@isect_nodes)){ 
     $x++;
     Help::verbose("2. Scanning both $srcdir/$lnode/pb-db.xml and $srcdir/$lnode/pb-db.xml file to find package information.");
     my $pb_xml_file = "$srcdir/$lnode/pb-db.xml";
     my $pb_fh       = XML::XPath->new(filename=>$pb_xml_file);
     my $sbdbxml     = "$srcdir/$lnode/sb-db.xml";
     my $sb_fh       = XML::XPath->new(filename=>$sbdbxml);
     my $PMS="pkgadd";
     $package_install_name = $lnode;

     if($OSP eq "solaris"){     
#     $package_install_name = $pb_fh->findvalue("/packages/package/package-manager[\@name='pkgadd']/install-name");
     $package_pkgname_base = $pb_fh->findvalue('/packages/package/package-manager[@name="pkgadd"]/pkgname-base');
     $package_version = $pb_fh->findvalue('/packages/package/package-manager[@name="pkgadd"]/version');
     $package_revision = $pb_fh->findvalue('/packages/package/package-manager[@name="pkgadd"]/revision');
     } elsif ($OSP eq "hp-ux"){
#     $package_install_name = $pb_fh->findvalue('/packages/package/package-manager[@name="depot"]/install-name');
     $package_pkgname_base = $pb_fh->findvalue('/packages/package/package-manager[@name="depot"]/pkgname-base');
     $package_version = $pb_fh->findvalue('/packaoges/package/package-manager[@name="depot"]/version');
     $package_revision = $pb_fh->findvalue('/packages/package/package-manager[@name="depot"]/revision');
     } elsif ($OSP eq "rhlinux"){
#     $package_install_name = $pb_fh->findvalue('/packages/package/package-manager[@name="rpm4"]/install-name');
     $package_pkgname_base = $pb_fh->findvalue('/packages/package/package-manager[@name="rpm4"]/pkgname-base');
     $package_version = $pb_fh->findvalue('/packages/package/package-manager[@name="rpm4"]/version');
     $package_revision = $pb_fh->findvalue('/packages/package/package-manager[@name="rpm4"]/revision');
     };
     $MF_LINE .= "\n#############################################################################\n";
     $MF_LINE .= "# $x / $total_sb_pb sb-pb package\n";

#page 55,perl &XML, p XML::XPath::XMLParser::as_string($depended_nodeset->get_nodelist)
#     <depend progname="binutils" module="gcc-3.2.2" state="installed">v==2.12.1</depend>
#      <dependencies>
#        <depend progname="binutils" module="gcc-3.2.2"
#          state="installed">v==2.12.1</depend>
# ppmgraph.pl is very helpful
   # $sb_fh->find('/programs/program/dependencies/depend/text()'); 
# Sample XML files.
# 
#     <dependencies>
#       <depend program="ghostscript" var="GHOSTSCRIPT"
#         install-name="ghostscript70">v&gt;=7.07</depend>
#       <depend program="pkgconfig" install-name="pkgconfig"
#         add-path="prepend" type="build">v&gt;=0.20</depend>
#       <depend program="gcc" var="GCC" add-path="prepend"
#         systype="*-aix4*|*-hpux10*">v==3.4.3</depend>
#       <depend program="freetype" var="LIBTTF"
#         install-name="libttf21">v&gt;=2.1.9</depend>
#       <depend program="t1lib" var="T1LIB"
#         install-name="t1lib51">v&gt;=5.1.0</depend>
#       <depend program="xpm" var="XPM">v&gt;=3.4k</depend>
#       <depend var="GCC_RT" install-name="gcc343r"
#         systype="*-aix4*|*-hpux10*"/>
#     </dependencies>
# 
#    my $depended_nodeset  = $sb_fh->findnodes('/programs/program/dependencies/depend/@install-name');

    my $depended_nodeset  = $sb_fh->findnodes('/programs/program/dependencies/depend/@program');
# hmm, array is empty
#   if ( my @nodelist = $depended_nodeset->get_nodelist)
#    {
#      @depended_proggram_list = map ($_->string_value,@nodelist);
#    }
#
    my $depended_install_string = ""; 
    my $depended_install_tmp = ""; 
 # Getting depended's program version number.
   my $depended_nodeset_ver  = $sb_fh->findnodes('/programs/program/dependencies/depend/text()');
   if ( my @nodelist = $depended_nodeset_ver->get_nodelist)
      {
      @versionlist  = map ($_->string_value, @nodelist );
  };

   foreach my $version  (@versionlist) {
    #before: v>=7.07
    $_ = $version;
    s/v//;
    s/>=//;
    s/==//;
    # after : 7.07
    push(@versionlist_no_ext,$_);
};

 #

#   foreach $node  (@depended_proggram_list,@versionlist)
#   {
#       print $node,"-",$version;
#   }
#      
  $i = 0;
  foreach my $node ($depended_nodeset->get_nodelist)
  {
    
    $tww_sb_graph->add_edge($lnode,$node->string_value());
    $depended_install_string .= " $program{install_prefix}/";

    # get the program name.
    my $depend_install_name_tmp = $node->string_value();

    # add the version number
       $depend_install_name_tmp .= "-".@versionlist_no_ext[$i];

    # dealing with install_name with NAME variable
    # <install-name>${NAME}561</install-name>
    if ($depend_install_name_tmp =~ /\${SB_PROG_NAME}/ )
    {
    $_ = $depend_install_name_tmp;   
    s/\${SB_PROG_NAME}//;
    $depended_install_string .=  $node->string_value();
    $depended_install_string .=  $_;    
    Help::verbose("    Found depended packages:",$depended_install_string,"\n");

#       if ($graph) {
#       my $tmp_program_name = $sb_fh->find("/programs/program/\@name");    
#       my $xx =$sb_fh->find("/programs/program/module[1]/install-name/text()");
#       if ($xx =~ /^\${SB_PROG_NAME}/){
#           $xx =~ s|^\${SB_PROG_NAME}||s;  
#       }
#       $tmp_program_name .= $xx;
#
#       my $tmp_depended_name .=  $node->string_value();
#          $tmp_depended_name .= $_;
#         $tww_graphviz->add_edge("$tmp_program_name" => "$tmp_depended_name",color=>"green" );
#       };
     }

    if($depend_install_name_tmp =~ /^v==/)
    {
    #/opt/TWWfsw/gcc322-gcc-3.2.2-binutils-2.12.1:
    my $y .=  $sb_fh->find("/programs/program/module[1]/dependencies/depend/\@progname");    
    my $m .=  $sb_fh->find("/programs/program/module[1]/dependencies/depend/\@module");    
    $depend_install_name_tmp =~ s|^v==||s; 
    $depended_install_string .=  $sb_fh->find("/programs/program/\@name");
    my $p =   $sb_fh->find("/programs/program/module[1]/install-name");
    if ($p =~ /\${SB_PROG_NAME}/ )
    {
    $p =~ s/\${SB_PROG_NAME}//;
    }
       
    $depended_install_string .=  $p;
    $depended_install_string .=  "-";    
    $depended_install_string .=  $m;    
    $depended_install_string .=  "-";    
    $depended_install_string .=  $y;    
    $depended_install_string .=  "-";    
    $depended_install_string .=  $depend_install_name_tmp;    
    }else
    {

#       if ($graph) {
#       my $tmp_program_name = $sb_fh->find("/programs/program/\@name");    
#       my $xx =$sb_fh->find("/programs/program/module[1]/install-name/text()");
#       if ($xx =~ /^\${SB_PROG_NAME}/){
#           $xx =~ s|^\${SB_PROG_NAME}||s;  
#       }
#       $tmp_program_name .= $xx;
#
#       my $tmp_depended_name .= $sb_fh->find("/programs/program/\@name");    
#          $tmp_depended_name .= $_;
#         $tww_graphviz->add_edge("$tmp_program_name" => "$depend_install_name_tmp",color=>"green" );
#        };
#
    $depended_install_string .= $depend_install_name_tmp;       
    $depended_install_string .= " ";

    }
    # move on next version number in versonlist
    $i++;

 }      #foreach my $node ($depended_nodeset->get_nodelist)


    Help::verbose("    depended_install_string: ", $depended_install_string,"\n");   

    if($OSP eq "solaris"){     
     $MF_LINE .= "ifeq (\$(upload),1) \n"; 
     $MF_LINE .= "$lnode: \\\n $program{install_prefix}/$package_install_name $dist_prefix/$package_pkgname_base"."u"." $lnode-gen-pkg-inst $lnode-upload \n"; 
     $MF_LINE .= "else  \n"; 
     $MF_LINE .= "$lnode: \\\n $program{install_prefix}/$package_install_name  \n"; 
     $MF_LINE .= "endif \n"; 
     } elsif ($OSP eq "hp-ux"){
     $MF_LINE .= "ifeq (\$(upload),1) \n"; 
     $MF_LINE .= "$lnode: \\\n $program{install_prefix}/$package_install_name $dist_prefix/$package_pkgname_base".".depot"." $lnode-gen-pkg-inst $lnode-upload \n";
     $MF_LINE .= "else  \n"; 
     $MF_LINE .= "$lnode: \\\n $program{install_prefix}/$package_install_name \n";
     $MF_LINE .= "endif \n"; 
     } elsif ($OSP eq "rhlinux"){
     $MF_LINE .= "ifeq (\$(upload),1) \n"; 
     $MF_LINE .= "$lnode: \\\n $program{install_prefix}/$package_install_name $dist_prefix/$package_pkgname_base-$package_version-$package_revision".".i386.rpm"." $lnode-gen-pkg-inst $lnode-upload \n";
     $MF_LINE .= "else  \n"; 
     $MF_LINE .= "$lnode: \\\n $program{install_prefix}/$package_install_name \n";
     $MF_LINE .= "endif \n"; 
     };


     $MF_LINE .= "#############################################################################\n";

      # build the static modules in a sb-db.xml file
      my $module_nodeset  = $sb_fh->find('/programs/program/module/@name');
      foreach my $node ($module_nodeset->get_nodelist){
      my $module_name = XML::XPath::XMLParser::as_string($node);
      $module_name =~ s|^ name="||s;
      $module_name =~ s|"||s;
      if ($module_name eq  "tww-static" ){
      $MF_LINE .= "$program{install_prefix}/$package_install_name";
      $MF_LINE .= "s:\n";
       Help::verbose("               module_name:", $module_name,"\n");
      $MF_LINE .= "\t\$\{SB\} -m $module_name \$\{SRCDIR\}/$lnode/sb-db.xml\n";
      $MF_LINE .= "\t\$\{SB\} -m $module_name -i \$\{SRCDIR\}/$lnode/sb-db.xml\n\n";
      }
      if ($module_name eq  "runtime" ){
      $MF_LINE .= "$program{install_prefix}/$package_install_name";
      $MF_LINE .= "r:\n";
       Help::verbose("               module_name:", $module_name,"\n");
      $MF_LINE .= "\t\$\{SB\} -m $module_name \$\{SRCDIR\}/$lnode/sb-db.xml\n";
      $MF_LINE .= "\t\$\{SB\} -m $module_name -i \$\{SRCDIR\}/$lnode/sb-db.xml\n\n";
      }

      }
     # declare the target and its depended target
     $MF_LINE .= "$program{install_prefix}/$package_install_name: \\ \n $depended_install_string\n";
     # then build the software
     $MF_LINE .= "\t\$\{SB\} \$\{SRCDIR\}/$lnode/sb-db.xml\n";
     # install the software
     $MF_LINE .= "\t\$\{SB\} -ip \$\{SRCDIR\}/$lnode/sb-db.xml\n";
     # build the modules beside default
      my $module_nodeset  = $sb_fh->find('/programs/program/module/@name');
      foreach my $node ($module_nodeset->get_nodelist){
      my $module_name = XML::XPath::XMLParser::as_string($node);
      $module_name =~ s|^ name="||s;
      $module_name =~ s|"||s;
      if ($module_name ne  "tww-static" and  $module_name ne  "default" and  $module_name ne  "runtime" ){    
       Help::verbose("               module_name:", $module_name,"\n");
      $MF_LINE .= "\t\$\{SB\} -m $module_name \$\{SRCDIR\}/$lnode/sb-db.xml\n";
      $MF_LINE .= "\t\$\{SB\} -m $module_name -i \$\{SRCDIR\}/$lnode/sb-db.xml\n";
      }

      }

     #  Writing the target:
     if($OSP eq "solaris"){     
     $MF_LINE .= "$dist_prefix/$package_pkgname_base"."u".":\n";
     } elsif ($OSP eq "hp-ux"){
     $MF_LINE .= "$dist_prefix/$package_pkgname_base".".depot".":\n";
     } elsif ($OSP eq "rhlinux"){
     $MF_LINE .= "$dist_prefix/$package_pkgname_base-$package_version-$package_revision".".i386.rpm".":\n";
     }

     # build the package into a one file format from package-name.pb instead of pb-db.xml
     $MF_LINE .= "\t\$\{PB\} -1 \$\{SRCDIR\}/$lnode/pb-db.xml";

     # Generate the pkg-inst, md5 for repository type installation
     $MF_LINE .= "\n$lnode-gen-pkg-inst: \n";
     $MF_LINE .= "\t\$\(call  update-depot-pkg-db,$lnode)\n";
     $MF_LINE .= "\t\$\{GPD\}  \$\{SRCDIR\}/$lnode/pb-db.xml >> $dist_prefix/pkg-db.xml\n";
     $MF_LINE .= "\t(cd $dist_prefix;zip  data.zip  $package_pkgname_base* ;\$\{M5S\}  data.zip |awk '{print \$\$1}' > data.zip.md5)\n";

     #  Writing accroding to platform:
     if($OSP eq "solaris"){     
     $MF_LINE .= "\t(cd $dist_prefix;zip -r  $lnode.pkgadd.pkg-inst pkg-db.xml data.zip data.zip.md5; \$\{M5S\}  $lnode.pkgadd.pkg-inst  |awk '{print \$\$1}' > $lnode.pkgadd.pkg-inst.md5)\n";

     } elsif ($OSP eq "hp-ux"){
     $MF_LINE .= "\t(cd $dist_prefix;zip -r  $lnode.depot.pkg-inst pkg-db.xml data.zip data.zip.md5;\$\{M5S\}  $lnode.depot.pkg-inst  |awk '{print \$\$1}' > $lnode.depot.pkg-inst.md5)\n";
     } elsif ($OSP eq "rhlinux"){
     $MF_LINE .= "\t(cd $dist_prefix;zip -r  $lnode.rpm.pkg-inst pkg-db.xml data.zip data.zip.md5;\$\{M5S\}  $lnode.rpm.pkg-inst  |awk '{print \$\$1}' > $lnode.rpm.pkg-inst.md5)\n";
     }

     $MF_LINE .= "\tcd $dist_prefix;rm -f pkg-db.xml data.zip data.zip.md5\n";

     # upload to respository server
     $MF_LINE .= "\n\n$lnode-upload: \n";


     #  Writing accroding to platform:
     if($OSP eq "solaris"){     
     $MF_LINE .= "\tcd $dist_prefix;\$\{RSYNC\} $lnode.pkgadd.pkg-inst $lnode.pkgadd.pkg-inst.md5 root\@apps.comm.mot.com:/export/dist/cd/\$\{ARCHI\}/\n";
     $MF_LINE .= "\tcd $dist_prefix;rm -f $dist_prefix/pkg-db.xml $lnode.pkgadd.pkg-inst $lnode.pkgadd.pkg-inst.md5\n\n";

     } elsif ($OSP eq "hp-ux"){

     $MF_LINE .= "\tcd $dist_prefix;\$\{RSYNC\}   $lnode.depot.pkg-inst $lnode.depot.pkg-inst.md5 root\@apps.comm.mot.com:/export/dist/cd/\$\{ARCHI\}/\n";
     $MF_LINE .= "\tcd $dist_prefix;rm -f $dist_prefix/pkg-db.xml $lnode.depot.pkg-inst $lnode.depot.pkg-inst.md5\n\n";


     } elsif ($OSP eq "rhlinux"){
     $MF_LINE .= "\tcd $dist_prefix;\$\{RSYNC\}   $lnode.rpm.pkg-inst $lnode.rpm.pkg-inst.md5 root\@apps.comm.mot.com:/export/dist/cd/\$\{ARCHI\}/\n";
     $MF_LINE .= "\tcd $dist_prefix;rm -f $dist_prefix/pkg-db.xml $lnode.rpm.pkg-inst $lnode.rpm.pkg-inst.md5\n\n";

     }
   # create the clean entry 
     $MF_LINE .= "$lnode-clean: \n";
     $MF_LINE .= "\t rm -rf \$\{BPFX\}/$lnode \$\{IPFX\}/$package_install_name $program{install_prefix}/.sb/$lnode\n\n ";
      
    $pb_fh -> cleanup();
    $sb_fh -> cleanup();
 }

  
     $MF_LINE .= "genpkgdb: \n";
     $MF_LINE .= "\t rm -f $dist_prefix/pkg-db.xml; ";
     $MF_LINE .= "\$\{GPD\} ";

     foreach my $lnode (sort(@isect_nodes)) {
     $MF_LINE .= "\$\{SRCDIR\}/$lnode/pb-db.xml ";
     }

     $MF_LINE .= " >> $dist_prefix/pkg-db.xml;";
     $MF_LINE .= "\$\{RSYNC\} $dist_prefix/pkg-db.xml  root\@apps.comm.mot.com:/export/dist/cd/${ARCHI}/\n";
     $MF_LINE .= "\n\n";
     $MF_LINE .= "genpkglist: \n";
     $MF_LINE .= "\techo ";
     foreach my $lnode (sort(@isect_nodes)) {
     $MF_LINE .= "\"$lnode\\n\" ";
     }

     $MF_LINE .= " >> $dist_prefix/pkgackage-list";
     $MF_LINE .= "\n\n";

     $MF_LINE .= "clean: cleaninstall cleanpkgdb cleanpackages\n\n";
     $MF_LINE .= "cleaninstall: \n";
     $MF_LINE .= "\trm -rf ";

     foreach my $lnode (sort(@isect_nodes)) {
     Help::verbose("3rd. Scanning of $srcdir/$lnode/$lnode/pb-db.xml file to make up targets of cleaninstall.");
     my $pb_xml_file = "$srcdir/$lnode/pb-db.xml";
     my $pb_fh = XML::XPath->new(filename=>$pb_xml_file);
     my $package_install_name = $pb_fh->findvalue('/packages/package/package-manager[@name="pkgadd"]/install-name');
     $MF_LINE .= "$program{install_prefix}/$package_install_name"; 
     $MF_LINE .= " ";
     $pb_fh -> cleanup();

     }
     $MF_LINE .= "\n\n";
     $MF_LINE .= "cleanpkgdb: \n";
     $MF_LINE .= "\trm -rf $dist_prefix/pkg-db.xml ";
     $MF_LINE .= "\n\n";
     $MF_LINE .= "cleanpackages: \n";
     $MF_LINE .= "\trm -rf ";

     foreach my $lnode (sort(@isect_nodes)) {
     Help::verbose("4th. Scanning of $srcdir/$lnode/pb-db.xml  XML file to make up targets of cleanpackages.");
     my $pb_xml_file = "$srcdir/$lnode/pb-db.xml";
     my $pb_fh = XML::XPath->new(filename=>$pb_xml_file);
     my $package_pkgname_base = $pb_fh->findvalue('/packages/package/package-manager[@name="pkgadd"]/pkgname-base');
     $MF_LINE .= "$dist_prefix/$package_pkgname_base\*"; 
     $MF_LINE .= " ";

     $pb_fh -> cleanup();
     }
     $MF_LINE .= "\n\n";
     Help::verbose("Makefile.$OSP.common generated.\n");
     my $MF = new IO::File ">$program{outdir}/Makefile.$OSP.common" || die "unable to create output '$program{outdir}/Makefile.$OSP.common'";
     $MF->print($MF_LINE);
     $MF->close;
     print "Makefile.$OSP.common generated.\n";
 }
}





