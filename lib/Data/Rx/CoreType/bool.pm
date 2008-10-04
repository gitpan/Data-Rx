use strict;
use warnings;
package Data::Rx::CoreType::bool;
our $VERSION = '0.003';

use base 'Data::Rx::CoreType';
# ABSTRACT: the Rx //bool type

sub check {
  my ($self, $value) = @_;

  return(
    defined($value)
    and ref($value)
    and (
      eval { $value->isa('JSON::XS::Boolean') }
      or
      eval { $value->isa('boolean') }
    )
  );
}

sub subname   { 'bool' }

1;

__END__

=pod

=head1 NAME

Data::Rx::CoreType::bool - the Rx //bool type

=head1 VERSION

version 0.003

=head1 AUTHOR

  Ricardo SIGNES <rjbs@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2008 by Ricardo SIGNES.

This is free software; you can redistribute it and/or modify it under
the same terms as perl itself.

=cut 


