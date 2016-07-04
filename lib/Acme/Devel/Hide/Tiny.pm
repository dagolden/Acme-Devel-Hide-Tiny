use 5.008001;
use strict;
use warnings;

package Acme::Devel::Hide::Tiny;
# ABSTRACT: Hide a perl module for testing, in one statement

our $VERSION = '0.002';

1;

=head1 SYNOPSIS

    # in 'foo.t', assume we want to hide Cpanel::JSON::XS

    # hide Cpanel::JSON::XS -> Cpanel/JSON/XS.pm
    use lib map {
        my $m = $_;
        sub { return unless $_[1] eq $m; die "Can't locate $_[1] in \@INC (hidden)\n"; }
    } qw{Cpanel/JSON/XS.pm};

=head1 DESCRIPTION

The L<Devel::Hide> and L<Test::Without::Module> modules are very helpful
development tools.  Unfortunately, using them in your F<.t> files adds a
test dependency.  Maybe you don't want to do that.

Instead, you can use the one-liner from the SYNOPSIS above, which is an
extremely stripped down version of L<Devel::Hide>.

Here is a more verbose, commented version of it:

    # 'lib' adds its arguments to the front of @INC
    use lib

        # add one coderef per path to hide
        map {
            # create lexical for module
            my $m = $_;

            # construct and return a closure that dies for the module path to hide
            sub {

                # return if not the path to hide; perl checks rest of @INC
                return unless $_[1] eq $m;

                # die with the error message we want
                die "Can't locate $_[1] in \@INC (hidden)\n";
            }
        }

        # input to map is a list module names, converted to paths;
        qw{Cpanel/JSON/XS.pm JSON/XS.pm}

    ; # end of 'use lib' statement

When perl sees a coderef in C<@INC>, it gives the coderef a chance to
provide the source code of that module.  In this case, if the path is the
one we want to hide, it dies with the message we want and perl won't
continue looking at C<@INC> to find the real module source.  The module is
hidden and dies with a message similar to the one that would happen if it
weren't installed.

=cut

# vim: ts=4 sts=4 sw=4 et tw=75:
