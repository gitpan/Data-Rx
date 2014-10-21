use strict;
use warnings;
package Data::Rx::CoreType::bool;
{
  $Data::Rx::CoreType::bool::VERSION = '0.200003';
}
use parent 'Data::Rx::CoreType';
# ABSTRACT: the Rx //bool type

sub assert_valid {
  my ($self, $value) = @_;

  return 1 if (
    defined($value)
    and ref($value)
    and (
      eval { $value->isa('JSON::XS::Boolean') }
      or
      eval { $value->isa('JSON::PP::Boolean') }
      or
      eval { $value->isa('boolean') }
    )
  );

  $self->fail({
    error   => [ qw(type) ],
    message => "found value was not a bool",
    value   => $value,
  });
}

sub subname   { 'bool' }

1;

__END__

=pod

=head1 NAME

Data::Rx::CoreType::bool - the Rx //bool type

=head1 VERSION

version 0.200003

=head1 AUTHOR

Ricardo SIGNES <rjbs@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by Ricardo SIGNES.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
