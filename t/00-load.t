#!perl -T

use Test::More tests => 1;

BEGIN {
    use_ok( 'CPAM::TWW' ) || print "Bail out!
";
}

diag( "Testing CPAM::TWW $CPAM::TWW::VERSION, Perl $], $^X" );
