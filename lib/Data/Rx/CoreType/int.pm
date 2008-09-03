use strict;
use warnings;
package Data::Rx::CoreType::int;
our $VERSION = '0.002';

use base 'Data::Rx::CoreType::num';
# ABSTRACT: the Rx //int type

sub subname   { 'int' }

sub check {
  my ($self, $value) = @_;
  return unless $self->SUPER::check($value);
  return unless $value == int $value;
  return 1;
}

1;

__END__

=pod

=head1 NAME

Data::Rx::CoreType::int - the Rx //int type

=head1 VERSION

version 0.002

=head1 AUTHOR

  Ricardo SIGNES <rjbs@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2008 by Ricardo SIGNES.

This is free software; you can redistribute it and/or modify it under
the same terms as perl itself.

=cut 


