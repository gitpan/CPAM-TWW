=head1 NAME

CPAM::TWW::Help - Help module to print out help message.

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
#  Help.pm  - 
#  Contains resuable common operations perl codes for Help functionality
#    
#
# REVISION HISTORY
#  12/24/2010 T.J. Yang
#
# USAGE: 
#  see following examples for your perl code to call up this perl module.
#  use lib '.';   # we are expecting ./Help.pm 
#  use Help;
package CPAM::TWW::Help;
#use Net::LDAP;
#
#
# DESCRIPTION
#  This perl module is to standerize common help functionality used within the account automation
#
#  Help::display_group
#  Help::display_shell
#  Help::display_home_quota
#  Help::display_view_quota

# References: 
# Books
# 1. Writing Perl Modules for CPAN,ISBN: 1-59059-018-x
# 2. 
# 3. 
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
# ---------------------------- PARAMETER DECLARATION --------------------------
#



=head1 SUBROUTINES/METHODS

=head2 general

=cut

sub general {
    my $script_name = shift;
    print  "Usage: $script_name [options]\n" .
           "No options will go into VT100 GUI interactive mode.\n" .
	   "Available options:\n" .
	   " -h,--help          print out this usage page\n" .
	   " -v,--verbose       enable verbose message\n" .
	   " -c,--create        create an account \n" .
           " -a,--adminid       admin id will prompt for password\n" .
	   " -c,--coreid=NAME   core id \n" .
	   " -u,--unixid=NAME   unix id \n" .
	   " -g,--groupid=NAME  group id \n" .
	   " -m,--home_quota= nnn Mbyte home directory size.\n" .
	   " -v,--view_quota= nnn Mbyte view directory quota size.\n" .
	   " Example: $script_name --create  --coreid=abc123  --adminid=abc321 \n" 
}



1;
