use inc::Module::Install;

name     'CPAM-TWW';
all_from 'lib/CPAM/TWW.pm';
author   q{T.J. Yang <tjyang2001@gmail.com>};
license  'gpl';

build_requires 'Test::More';
requires 'Getopt::Long' => '2.38'; # to process sb2make.pl's arguments.
requires 'IO' => '1.25'; 
requires 'Data::Dumper' => '2.124';
requires 'XML::LibXML' => '1.70';  # to parse TWW's package in XML format.
requires 'XML::XPath' => '1.13';   # to parse TWW's package in XML format.
requires 'Graph' => '0.90';        # to build package dependcy into Math Graph.
requires 'GraphViz' => '2.04';     # to depict package dependcy in picture graph.
requires 'Config::General' => '2.44'; # This should reflect the config file format you've chosen

install_script glob('script/*.pl');
install_script glob('script/sb');
install_script glob('script/pb');

auto_install;

WriteAll;

