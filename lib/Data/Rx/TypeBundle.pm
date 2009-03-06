use strict;
use warnings;
package Data::Rx::TypeBundle;
our $VERSION = '0.007';

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

=head1 NAME

Data::Rx::TypeBundle - base class for type bundles

=head1 VERSION

version 0.007

=head1 AUTHOR

  Ricardo SIGNES <rjbs@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2009 by Ricardo SIGNES.

This is free software; you can redistribute it and/or modify it under
the same terms as perl itself.

=cut 


