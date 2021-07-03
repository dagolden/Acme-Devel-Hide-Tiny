use 5.008001;
use strict;
use warnings;

package Acme::Devel::Hide::Tiny;
# ABSTRACT: Hide a perl module for testing, in one statement

our $VERSION = '0.003';

1;

=head1 SYNOPSIS

    # in 'foo.t', assume we want to hide Cpanel::JSON::XS

    # hide Cpanel::JSON::XS -> Cpanel/JSON/XS.pm
    use lib sub {
        return unless $_[1] eq q{Cpanel/JSON/XS.pm};
        die "Can't locate $_[1] in \@INC (hidden)\n";
    };

=head1 DESCRIPTION

The L<Devel::Hide> and L<Test::Without::Module> modules are very helpful
development tools.  Unfortunately, using them in your F<.t> files adds a
test dependency.  Maybe you don't want to do that.
Instead, you can use the code from the L</SYNOPSIS> above, which is an
extremely stripped down version of L<Devel::Hide>.
To hide multiple modules, simply repeat the C<return unless> line.

When perl sees a coderef in C<@INC>, it gives the coderef a chance to
provide the source code of that module.  In this case, if the path is the
one we want to hide, it dies with the message we want and perl won't
continue looking at C<@INC> to find the real module source.  The module is
hidden and dies with a message similar to the one that would happen if it
weren't installed.

=cut

# vim: ts=4 sts=4 sw=4 et tw=75:
