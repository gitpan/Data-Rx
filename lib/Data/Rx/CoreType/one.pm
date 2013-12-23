use strict;
use warnings;
package Data::Rx::CoreType::one;
{
  $Data::Rx::CoreType::one::VERSION = '0.200005';
}
use parent 'Data::Rx::CoreType';
# ABSTRACT: the Rx //one type

sub assert_valid {
  my ($self, $value) = @_;

  if (! defined $value) {
    $self->fail({
      error   => [ qw(type) ],
      message => "found value is undef",
      value   => $value,
    });
  }

  return 1 unless ref $value and ! (
    eval { $value->isa('JSON::XS::Boolean') }
    or
    eval { $value->isa('JSON::PP::Boolean') }
    or
    eval { $value->isa('boolean') }
  );

  $self->fail({
    error   => [ qw(type) ],
    message => "found value is a reference/container type",
    value   => $value,
  });
}

sub subname   { 'one' }

1;

__END__

=pod

=encoding UTF-8

=head1 NAME

Data::Rx::CoreType::one - the Rx //one type

=head1 VERSION

version 0.200005

=head1 AUTHOR

Ricardo SIGNES <rjbs@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by Ricardo SIGNES.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
