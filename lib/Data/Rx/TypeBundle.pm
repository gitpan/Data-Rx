use strict;
use warnings;
package Data::Rx::TypeBundle;
{
  $Data::Rx::TypeBundle::VERSION = '0.200005';
}
# ABSTRACT: base class for type bundles

sub prefix_pairs {
  return if ref $_[0] and $_[0]->{no_prefix};
  $_[0]->_prefix_pairs;
}

sub without_prefix {
  bless { no_prefix => 1 } => $_[0];
}

1;

__END__

=pod

=encoding UTF-8

=head1 NAME

Data::Rx::TypeBundle - base class for type bundles

=head1 VERSION

version 0.200005

=head1 AUTHOR

Ricardo SIGNES <rjbs@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by Ricardo SIGNES.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
