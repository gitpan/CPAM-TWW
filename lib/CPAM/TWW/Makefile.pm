=head1 NAME

CPAM::TWW - The great new CPAM::TWW!

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';


=head1 SYNOPSIS

Quick summary of what the module does.

Perhaps a little code snippet.

    use CPAM::TWW;

    my $foo = CPAM::TWW->new();
    ...

=head1 EXPORT

A list of functions that can be exported.  You can delete this section
if you don't export anything, such as for a purely object-oriented module.


=head1 AUTHOR

T.J. Yang, C<< <tjyang2001 at gmail.com> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-cpam-tww at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=CPAM-TWW>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.




=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc CPAM::TWW


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=CPAM-TWW>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/CPAM-TWW>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/CPAM-TWW>

=item * Search CPAN

L<http://search.cpan.org/dist/CPAM-TWW/>

=back


=head1 ACKNOWLEDGEMENTS


=head1 LICENSE AND COPYRIGHT

Copyright 2010 T.J. Yang.

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; version 2 dated June, 1991 or at your option
any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

A copy of the GNU General Public License is available in the source tree;
if not, write to the Free Software Foundation, Inc.,
59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.


=cut



# -----------------------------------------------------------------------------
#                     S C R I P T   S P E C I F I C A T I O N
# -----------------------------------------------------------------------------
#
# NAME
#  TWW.pm  - 
#  A module to do checking on account creation.
#    
#
# REVISION HISTORY
#  11/20/2010    T.J. Yang           original
#
# USAGE: 
#
# DESCRIPTION
#  This perl module is to standerize common ldap operatons to a ldap server.
#  The operations (search,add,delete,modify) are subroutines in TWW package.
#
# Makefile::search(TWW,key);
# Makefile::
# Makefile::
# Makefile::
# Makefile::

# References: 
# online
# Books
# 1. Writing Perl Modules for CPAN,ISBN: 1-59059-018-x
#
# OPTIONS
#
# EXAMPLES
#
# RETURN CODE
#       SUCCESS (=0) - script completed successfully
#       ERROR   (=1) - error ... bad things happened
#       SKIP    (=2) - startup or shutdown was skipped

# WHAT: Define PATH.
# WHY:  Mainly for security reasons.
# NOTE: This should only be changed if you know what you're doing.
#
# WHAT: Define exit status flags.
# WHY:  Easier to program with a mnemonic than with the numbers.
# NOTE: THESE DO NOT CHANGE UNLESS NOTIFIED BY HP!  Startup depends on these
#       exit statuses being defined this way.
#
# **************************** MAIN SCRIPT ************************************
#
# ------------------------------- TRAP DECLARATION ----------------------------
#
# ---------------------------- CONSTANT DECLARATION ---------------------------
#
#
# ---------------------------- VARIABLE DECLARATION ---------------------------
#
#
# ---------------------------- OPTION DECLARATION -----------------------------
#
#

use XML::LibXML;
use XML::XPath;
package CPAM::TWW::Makefile;


=head1 SUBROUTINES/METHODS

=head2 MyDistHeader 

=cut


#     ##############################################################################
#    #                                                                            ##
#   ############################################################################## #
#   #                                                                            # #
#   #   MyDistHeader                                                           # #
#   #                                                                            ##
#   ##############################################################################
#

sub MyDistHeader {
    my ($line) = @_;
    my $hdr = 
	  "#                     $line\n" .
	  "# -----------------------------------------------------------------------------\n" .
	  "#                     S C R I P T   S P E C I F I C A T I O N\n" .
	  "# -----------------------------------------------------------------------------\n" .
	  "# NAME\n" .
	  "#       Makefile  - A gnu makefile to wrapp around TWW's sb and pb tools.\n" .
	  "#\n" .
	  "#\n" .
	  "# REVISION HISTORY\n" .
	  "#     May 22 2004   by  TJ Yang original.\n" .
	  "#\n" .
	  "#\n" .
	  "# USAGE\n" .
	  "#       gmake \n" .
	  "#\n" .
	  "# DESCRIPTION\n" .
	  "#       This makefile will find out its OS platform and include corresponded makefile\n" .
	  "#       to make package for that platform\n" .
	  "#\n" .
	  "#\n" .
	  "# ********************************* MAIN SCRIPT *******************************\n" .
	  "#\n". 
	  "# ------------------------------- TRAP DECLARATION ----------------------------\n" .
	  "#\n" .
	  "# **************************** FUNCTION DEFINITION ****************************\n" .
	  "#\n" .
	  "# ---------------------------- CONSTANT DECLARATION ---------------------------\n" .
	  "# NOTE: DO NOT CHANGE UNLESS YOU KNOW WHAT YOU ARE DOING!!!\n" .
	  "#\n" .

	  "#\n" .
	  "\n";
    return $hdr;
}


#     ##############################################################################
#    #                                                                            ##
#   ############################################################################## #
#   #                                                                            # #
#   #   hdr                                                                      # #
#   #                                                                            ##
#   ##############################################################################
#


=head2 hdr 

=cut

sub hdr {
    my ($line) = @_;
    my $hdr = 
	  "##\n" .
	  "##  A Makefile to build and package TWW's .sb and .pb file into different\n" .
	  "##  supported OSs.\n\n" .
	  "##  This file is generated by $progname. \n" .
	  "##  You can edit this file if you are confident. \n" .
	  "##\n" .
	  "##  Copyright (c) 05/21/2003  TJ Yang     <me\@myaccount.com>\n" .
	  "##  Idea copied from src2make.pl in openpkg project (http://www.openpkg.org).\n" .
	  "##\n" .
	  "##  Permission to use, copy, modify, and distribute this software for\n" .
	  "##  any purpose with or without fee is hereby granted, provided that\n" .
	  "##  the above copyright notice and this permission notice appear in all\n" .
	  "##  copies.\n" .
	  "##\n" .
	  "##  THIS SOFTWARE IS PROVIDED ``AS IS'' AND ANY EXPRESSED OR IMPLIED\n" .
	  "##  WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF\n" .
	  "##  MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.\n" .
	  "##  IN NO EVENT SHALL THE AUTHORS AND COPYRIGHT HOLDERS AND THEIR\n" .
	  "##  CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,\n" .
	  "##  SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT\n" .
	  "##  LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF\n" .
	  "##  USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND\n" .
	  "##  ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,\n" .
	  "##  OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT\n" .
	  "##  OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF\n" .
	  "##  SUCH DAMAGE.\n" .
	  "##\n" .
	  "##  $line\n" .
	  "##\n" .
	  "\n";
    return $hdr;
}



=head2 GenMakefile 

=cut


#     ##############################################################################
#    #                                                                            ##
#   ############################################################################## #
#   #                                                                            # #
#   #   GenMakefile                                                              # #
#   #                                                                            ##
#   ##############################################################################
#

sub GenMakefile {
     my %myprogram = @_;
     my $MMF_LINE='';
     $MMF_LINE .= &MyDistHeader(" SEC Unix ITIS MyDist Script Header  ");
     $MMF_LINE .= "BPFX=$myprogram{bbuild_prefix}\n";
     $MMF_LINE .= "IPFX=$myprogram{iinstall_prefix}\n";
     $MMF_LINE .= "DISTPFX=$myprogram{$ddist_prefix}\n";
     $MMF_LINE .= "ifeq (\$(shell  /opt/TWWfsw/pkgutils15/lib/systype),sparc-sun-solaris2.6)\n";
     $MMF_LINE .= "ARCHI=sparc-sun-solaris2.6\n";
     $MMF_LINE .= "include Makefile.common\n";
     $MMF_LINE .= "include Makefile.solaris.common\n";
     $MMF_LINE .= "include Makefile.perl-5.6.1-modules\n";
     $MMF_LINE .= "else\n";

     $MMF_LINE .= "ifeq (\$(shell  /opt/TWWfsw/pkgutils15/lib/systype),sparc-sun-solaris2.8)\n";
     $MMF_LINE .= "ARCHI=sparc-sun-solaris2.8\n";
     $MMF_LINE .= "include Makefile.common\n";
     $MMF_LINE .= "include Makefile.solaris.common\n";
     $MMF_LINE .= "include Makefile.perl-5.6.1-modules\n";
     $MMF_LINE .= "else\n";

     $MMF_LINE .= "ifeq (\$(shell  /opt/TWWfsw/pkgutils15/lib/systype),sparc-sun-solaris2.9)\n";
     $MMF_LINE .= "ARCHI=sparc-sun-solaris2.9\n";
     $MMF_LINE .= "include Makefile.common\n";
     $MMF_LINE .= "include Makefile.solaris.common\n";
     $MMF_LINE .= "include Makefile.perl-5.6.1-modules\n";
     $MMF_LINE .= "else\n";


     $MMF_LINE .= "ifeq (\$(shell  /opt/TWWfsw/pkgutils15/lib/systype),sparc-sun-solaris2.10)\n";
     $MMF_LINE .= "ARCHI=sparc-sun-solaris2.10\n";
     $MMF_LINE .= "include Makefile.common\n";
     $MMF_LINE .= "include Makefile.solaris.common\n";
     $MMF_LINE .= "include Makefile.perl-5.6.1-modules\n";
     $MMF_LINE .= "else\n";

     $MMF_LINE .= "ifeq (\$(shell  /opt/TWWfsw/pkgutils15/lib/systype),sparc-sun-solaris2.11)\n";
     $MMF_LINE .= "ARCHI=sparc-sun-solaris2.11\n";
     $MMF_LINE .= "include Makefile.common\n";
     $MMF_LINE .= "include Makefile.solaris.common\n";
     $MMF_LINE .= "include Makefile.perl-5.6.1-modules\n";
     $MMF_LINE .= "else\n";


     $MMF_LINE .= "ifeq (\$(shell  /opt/TWWfsw/pkgutils15/lib/systype),i686-redhat-linux7.3)\n";
     $MMF_LINE .= "ARCHI=i686-redhat-linux7.3\n";
     $MMF_LINE .= "include Makefile.common\n";
     $MMF_LINE .= "include Makefile.rhlinux.common\n";
     $MMF_LINE .= "include Makefile.perl-5.6.1-modules\n";
     $MMF_LINE .= "else\n";

     $MMF_LINE .= "ifeq (\$(shell  /opt/TWWfsw/pkgutils15/lib/systype),i686-redhat-linux9)\n";
     $MMF_LINE .= "ARCHI=i686-redhat-linux9\n";
     $MMF_LINE .= "include Makefile.common\n";
     $MMF_LINE .= "include Makefile.rhlinux.common\n";
     $MMF_LINE .= "include Makefile.perl-5.6.1-modules\n";
     $MMF_LINE .= "else\n";


     $MMF_LINE .= "ifeq (\$(shell  /opt/TWWfsw/pkgutils15/lib/systype),i686-redhat-linuxe3)\n";
     $MMF_LINE .= "ARCHI=i686-redhat-linuxe3\n";
     $MMF_LINE .= "include Makefile.common\n";
     $MMF_LINE .= "include Makefile.rhlinux.common\n";
     $MMF_LINE .= "include Makefile.perl-5.6.1-modules\n";
     $MMF_LINE .= "else\n";

     $MMF_LINE .= "ifeq (\$(shell  /opt/TWWfsw/pkgutils15/lib/systype),i686-redhat-linuxe4)\n";
     $MMF_LINE .= "ARCHI=i686-redhat-linuxe4\n";
     $MMF_LINE .= "include Makefile.common\n";
     $MMF_LINE .= "include Makefile.rhlinux.common\n";
     $MMF_LINE .= "include Makefile.perl-5.6.1-modules\n";
     $MMF_LINE .= "else\n";

     $MMF_LINE .= "ifeq (\$(shell  /opt/TWWfsw/pkgutils15/lib/systype),hppa1.1-hp-hpux10.20)\n";
     $MMF_LINE .= "ARCHI=hppa1.1-hp-hpux10.20\n";
     $MMF_LINE .= "include Makefile.common\n";
     $MMF_LINE .= "include Makefile.hp-ux.common\n";
     $MMF_LINE .= "include Makefile.perl-5.6.1-modules\n";
     $MMF_LINE .= "else\n";

     $MMF_LINE .= "ifeq (\$(shell  /opt/TWWfsw/pkgutils15/lib/systype),hppa1.1-hp-hpux11.11)\n";
     $MMF_LINE .= "ARCHI=hppa1.1-hp-hpux11.11\n";
     $MMF_LINE .= "include Makefile.common\n";
     $MMF_LINE .= "include Makefile.hp-ux.common\n";
     $MMF_LINE .= "include Makefile.perl-5.6.1-modules\n";
     $MMF_LINE .= "else\n";

     $MMF_LINE .= "ifeq (\$(shell  /opt/TWWfsw/pkgutils15/lib/systype),hppa1.1-hp-hpux11.23)\n";
     $MMF_LINE .= "ARCHI=hppa1.1-hp-hpux11.23\n";
     $MMF_LINE .= "include Makefile.common\n";
     $MMF_LINE .= "include Makefile.hp-ux.common\n";
     $MMF_LINE .= "include Makefile.perl-5.6.1-modules\n";
     $MMF_LINE .= "else\n";


     $MMF_LINE .= "cantbuild:\n";
     $MMF_LINE .= "\t\@echo \"Error:  \$(shell  /opt/TWWfsw/pkgutils15/lib/systype) target OS is not supported\n";
     $MMF_LINE .= "endif\n";
     $MMF_LINE .= "endif\n";
     $MMF_LINE .= "endif\n";
     $MMF_LINE .= "endif\n";
     $MMF_LINE .= "endif\n";
     $MMF_LINE .= "endif\n";
     $MMF_LINE .= "endif\n";
     $MMF_LINE .= "endif\n";
     $MMF_LINE .= "endif\n";
     $MMF_LINE .= "endif\n";
     $MMF_LINE .= "endif\n";

     $MMF_LINE .= qq(# Global functions \n);
     $MMF_LINE .= qq(# $(call update-depot-pkg-db,pkgname)\n);
     $MMF_LINE .= qq(# $1 is the first argument.\n);
     $MMF_LINE .= qq(\n);
     $MMF_LINE .= qq(define update-depot-pkg-db\n);
     $MMF_LINE .= qq(	\${RSYNC} \${DST}/\${ARCHI}/pkg-db.xml /tmp;\n);
     $MMF_LINE .= qq(	perl -pi -e 's!</packages>!!' /tmp/pkg-db.xml\n);
     $MMF_LINE .= qq(	\${GPD}  \${SRCDIR}/$1/pb-db.xml > /tmp/tmp.xml\n);
     $MMF_LINE .= qq(	perl -pi -e 's!^</packages>!!' /tmp/tmp.xml\n);
     $MMF_LINE .= qq(	perl -pi -e 's!^<packages>!!' /tmp/tmp.xml\n);
     $MMF_LINE .= qq(	perl -pi -e 's!^<\?xml version="1.0"\?>!!' /tmp/tmp.xml\n);
     $MMF_LINE .= qq(	cat /tmp/tmp.xml  >> /tmp/pkg-db.xml;rm -f /tmp/tmp.xml\n);
     $MMF_LINE .= qq(	echo "</packages>" >> /tmp/pkg-db.xml\n);
     $MMF_LINE .= qq(	${RSYNC} /tmp/pkg-db.xml \${DST}/\${ARCHI}/\n);
     $MMF_LINE .= qq(endef\n);
     
     
     $MMF_LINE .= qq(# Global functions \n);
     $MMF_LINE .= qq(# \$(call buildprework,DISTNAME)\n);
     $MMF_LINE .= qq(# \$1 is the first argument.\n);
     $MMF_LINE .= qq(\n);
     $MMF_LINE .= qq(define buildprework\n);
     $MMF_LINE .= qq(	\@mkdir -p /opt/dist/\$1/cd  /opt/build/\$1 /opt/\$1\n);
     $MMF_LINE .= qq(	perl -pi -e 's!"/opt/build"!"/opt/build/\$1"!' /opt/TWWfsw/sbutils12/etc/sbutils.conf\n);
     $MMF_LINE .= qq(	perl -pi -e 's!"/opt/TWWfsw"!"/opt/\$1"!' /opt/TWWfsw/sbutils12/etc/sbutils.conf\n);
     $MMF_LINE .= qq(	perl -pi -e 's!"/opt/build"!"/opt/build/\$1"!' /opt/TWWfsw/pbutils11/etc/pbutils.conf\n);
     $MMF_LINE .= qq(	perl -pi -e 's!"/opt/dist/cd"!"/opt/dist/\$1/cd"!' /opt/TWWfsw/pbutils11/etc/pbutils.conf\n);
     $MMF_LINE .= qq(	perl -pi -e 's!"/opt/TWWfsw"!"/opt/\$1"!' /opt/TWWfsw/pbutils11/etc/pbutils.conf\n);
     $MMF_LINE .= qq(endef\n);
     
     $MMF_LINE .= qq(# Global functions \n);
     $MMF_LINE .= qq(# \$(call change_disname,DEFAULT,DISTNAME)\n);
     $MMF_LINE .= qq(# \$1 is the first argument.\n);
     $MMF_LINE .= qq(\n); 
     $MMF_LINE .= qq(define change_disname\n);
     $MMF_LINE .= qq(	perl -pi -e 's!\$1!\$2!' */pb-db.xml\n);
     $MMF_LINE .= qq(endef\n);



     my $MMF = new IO::File ">$myprogram{outdir}/Makefile" || die "unable to create output '$myprogram{outdir}/Makefile'\n";
     $MMF->print($MMF_LINE);
     $MMF->close;
     print "Main Makefile generated.\n";
     Help::verbose("Main Makefile.$ARCHI generated.\n");

}

=head2 GenMakefileCommon 

=cut

#     ##############################################################################
#    #                                                                            ##
#   ############################################################################## #
#   #                                                                            # #
#   #   GenMakefileCommon                                                        # #
#   #                                                                            ##
#   ##############################################################################
#

sub GenMakefileCommon {
     my %myprogram = @_;
     my $MMF_LINE='';
     $MMF_LINE .= &MyDistHeader("Section of All targets -- ");
     $MMF_LINE .= "ifeq (\$(forcesb),1)\n";
     $MMF_LINE .= "SB=/opt/TWWfsw/bin/sb --force \n";
     $MMF_LINE .= "else\n";
     $MMF_LINE .= "SB=/opt/TWWfsw/bin/sb\n";
     $MMF_LINE .= "endif\n";


     $MMF_LINE .= "PB=/opt/TWWfsw/bin/pb\n";
     $MMF_LINE .= "ZIP=zip\n";
     $MMF_LINE .= "M5S=/opt/TWWfsw/bin/gmd5sum\n";
     $MMF_LINE .= "GPD=/opt/TWWfsw/bin/gen-pkg-db\n";
     $MMF_LINE .= "RSYNC=/opt/TWWfsw/rsync25/bin/rsync -azpv\n";
     $MMF_LINE .= "DST=root\@apps.comm.mot.com:/export/dist/cd\n";
     $MMF_LINE .= "SRCDIR=$SRCDIR\n";
     $MMF_LINE .= "all: allpkgs \n\n";
     $MMF_LINE .= "help: \n";
     $MMF_LINE .= "\t\@echo \n";
     $MMF_LINE .= "\t\@echo        help : to get this message.\n";
     $MMF_LINE .= "\t\@echo allpkgs: built package with both sb and pb\n";
     $MMF_LINE .= "\t\@echo allsb :  build sb only  packages\n";
     $MMF_LINE .= "\t\@echo                use  pb to package the packages\n";
     $MMF_LINE .= "\t\@echo                And finally upload all the files to apps.comm.mot.com\n";
     $MMF_LINE .= "\t\@echo gen-pkg-inst: generate pkg-db.xml contains all the indivisual pkg-db.xml.\n";
     $MMF_LINE .= "\t\@echo       upload: to upload all the .pkg-inst files upto repository server.\n";
     $MMF_LINE .= "\t\@echo \n\n";
     my $MF = new IO::File ">$myprogram{outdir}/Makefile.common" || die "unable to create output '$myprogram{outdir}/Makefile.common'";
     $MF->print($MMF_LINE);
     $MF->close;
     print "Makefile.common generated.\n";
     Help::verbose("Makefile.common generated.\n");
}



=head2 GenMakefilePerlModules 
=cut

#     ##############################################################################
#    #                                                                            ##
#   ############################################################################## #
#   #                                                                            # #
#   #   GenMakefilePerlModules                                                   # #
#   #                                                                            ##
#   ##############################################################################
#

sub GenMakefilePerlModules{
    my %myprogram = @_;
my $Text="
perl_modules: /opt/TWWfsw/perl561 /opt/TWWfsw/perl580 perl_modules_1   perl_modules_2  perl_modules_3  perl_modules_4 perl_modules_5

perl_modules_upload: perl-5.6.1-clean-packages perl-5.8.0-clean-packages \$\{DISTPFX\}/TWWpl561u \\
perl-5.6.1-gen-pkg-inst perl-5.6.1-upload \$\{DISTPFX\}/TWWpl580u perl-5.8.0-gen-pkg-inst perl-5.8.0-upload

perl_modules_upload_perl-5.6.1: perl-5.6.1-clean-packages \$\{DISTPFX\}/TWWpl561u perl-5.6.1-gen-pkg-inst perl-5.6.1-upload 

perl_modules_1: MIME-Base64-2.16 Text-Iconv-1.2 Term-ReadLine-Gnu-1.13 TermReadKey-2.21 Test-Simple-0.47 \\
Class-Data-Inheritable-0.02 Carp-Assert-0.17  Class-Fields-0.14 IO-stringy-2.108 Authen-SASL-2.02 \\
BWidget-1.5 BerkeleyDB-0.20 Bit-Vector-6.3 \\
Class-Accessor-0.17 Class-Trigger-0.05 DBI-1.30 Text-CSV_XS-0.23 \\
SQL-Statement-1.004 DBD-CSV-0.2002 Class-WhiteHole-0.03 Ima-DBI-0.27 Class-DBI-0.89  \\
Compress-Zlib-1.16 Convert-ASN1-0.14 Crypt-DES-2.03 Crypt-SSLeay-0.51 Curses-1.06 

perl_modules_2:  DBD-Pg-1.22 DB_File-1.805 Data-ShowTable-3.3 Data-Table-1.36 \\
Date-Calc-5.3 DateManip-5.39 Digest-MD5-2.23 File-PathConvert-0.9 \\
File-Remote-1.14 File-Spec-0.82 Time-HiRes-1.20 TimeDate-1.1301 \\
File-Tail-0.98 File-Temp-0.12 Filter-1.28 Text-Balanced-1.89 \\
Filter-Simple-0.78 Font-AFM-1.18 GDGraph-1.35 GDGraph-1.39 

perl_modules_3:  Heap-0.50  Graph-0.201 Graph-ReadWrite-1.07 \\
IPC-Run-0.75 Math-Bezier-0.01 GraphViz-1.5 GraphViz-DBI-0.01 \\
GraphViz-ISA-0.01 HTML-Tagset-3.03 HTML-Parser-3.27 HTML-Tree-3.13 \\
HTML-Format-1.23   HTML-Template-2.6 XML-Parser-2.31 XML-RegExp-0.03  \\
XML-Writer-0.4  XML-Twig-3.08  IO-Tty-1.02 URI-1.23 MailTools-1.58 \\
MIME-tools-5.411 MLDBM-2.00 Metadata-0.24 Msql-Mysql-modules-1.2219 \\
Storable-2.04  

perl_modules_4: libnet-1.12 libwww-perl-5.65 Net-Daemon-0.37 PlRPC-0.2016 \\
 Net-Telnet-3.02 Net_SSLeay-1.22 Parse-RecDescent-1.80 Parse-Yapp-1.05 \\
Proc-Background-1.08 Proc-Daemon-0.02 Proc-ProcessTable-0.38 \\
RPC-XML-0.51 Resources-1.04 SNMP_Session-0.93 GD-2.07  GDTextUtil-0.85  \\
IO-Zlib-1.01 Compress-Zlib-1.22 Digest-MD5-2.25  MSGraph-1.34  DBD-Oracle-1.14  \\
Spreadsheet-ParseExcel-0.2602  Spreadsheet-WriteExcel-0.41 Text-PDF-0.25 GD-Graph3d-0.63 \\
Expect-1.15 CPAN-1.71 

perl_modules_5: ImageMagick-5.5.3-perl Error-0.15 Tk-800.024 \\
OLE-Storage_Lite-0.11  Spreadsheet-ParseExcel-0.2602 XML-Excel-0.02 \\
XML-NamespaceSupport-1.08  XML-LibXML-Common-0.13 XML-SAX-0.12 XML-NodeFilter-0.01 XML-LibXML-1.54 \\
MIME-Lite-3.01 MIME-Lite-HTML-1.15

#R/RB/RBERJON/XML-NamespaceSupport-1.08.tar.gz
#M/MS/MSERGEANT/XML-SAX-0.12.tar.gz
#P/PH/PHISH/XML-NodeFilter-0.01.tar.gz

perl_modules_test: XML-XPath-1.13

perl_modules_test_notok:  DBD-mysql-2.1028 NetServer-Generic-1.03 
# /opt/TWWfsw/perl561/lib/5.6.1/CPAN/Config.pm
#Spreadsheet-WriteExcel XML-Parser-PerlSAX
#Problems: Archive-Tar-1.03 
#

#DBD::ODBC
#
#
#Spreadsheet::WriteExcel::Big
#PerlSAX
#

# Problem perl modules
#  (perl-5.8.0) XML-DOM-1.39 HTTP-DAV-0.31
#PDL-2.3.3  Quota-1.3.4 Mail-IMAPClient-2.2.7  
#
python_modules: python_modules_0
python_modules_0: Imaging-1.1.3  Numeric-23.0 ScientificPython-2.4.1 PyXML-0.8.2  PyQt-3.6 ReportLab-1.17 Optik-1.4 p
python_modules_1:python-ldap-2.0.0
#
tcl_modules: TclCurl-0.10.4  Tktable-2.8 

";


     my $MMF_LINE='';
     $MMF_LINE .= Makefile::MyDistHeader(" Makefe file Perl 5.6.1 modules -- ");

     $MMF_LINE .= "$Text\n\n";
     my $MF = new IO::File ">$myprogram{outdir}/Makefile.perl-5.6.1-modules" || die "unable to create output '$myprogram{outdir}/Makefile.perl-5.6.1-modules'";
     $MF->print($MMF_LINE);
     $MF->close;
     print "Makefile.perl-5.6.1-modules.\n";
     Help::verbose("Makefile.perl-5.6.1-modules generated.\n");

}






1;
