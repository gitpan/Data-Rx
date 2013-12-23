use strict;
use warnings;
package Data::Rx::CoreType::num;
{
  $Data::Rx::CoreType::num::VERSION = '0.200005';
}
use parent 'Data::Rx::CoreType';
# ABSTRACT: the Rx //num type

sub guts_from_arg {
  my ($class, $arg, $rx, $type) = @_;

  Carp::croak("unknown arguments to new")
    unless Data::Rx::Util->_x_subset_keys_y($arg, { range => 1, value => 1});

  my $guts = {};

  $guts->{range_check} = Data::Rx::Util->_make_range_check($arg->{range})
    if $arg->{range};

  if (exists $arg->{value}) {
    my $val = $arg->{value};
    if (
      (! defined $val)
      or ref $val
      or ! $class->_value_is_of_type($val)
    ) {
      Carp::croak(sprintf(
        'invalid value (%s) for //%s',
        defined $val ? $val : 'undef',
        $class->subname,
      ));
    }
  }

  $guts->{value} = $arg->{value} if defined $arg->{value};

  return $guts;
}

sub __type_fail {
  my ($self, $value) = @_;
  $self->fail({
    error   => [ qw(type) ],
    message => "value is not a number",
    value   => $value,
  });
}

my $_NUM_RE;
BEGIN {
  $_NUM_RE = qr/
    \A
      [-+]?
      (?:0|[1-9]\d*)
      (?:\.\d+)?
      (?:e
        (?:0|[1-9]\d*)
      )?
    \z
  /ix;
}

sub _value_is_of_type {
  my ($self, $value) = @_;

  return $value =~ $_NUM_RE;
}

sub assert_valid {
  my ($self, $value) = @_;

  $self->__type_fail($value) unless defined $value and length $value;

  # XXX: This is insufficiently precise.  It's here to keep us from believing
  # that JSON::XS::Boolean objects, which end up looking like 0 or 1, are
  # integers. -- rjbs, 2008-07-24
  $self->__type_fail($value) if ref $value;

  $self->__type_fail($value) unless $self->_value_is_of_type($value);

  if ($self->{range_check} && ! $self->{range_check}->($value)) {
    $self->fail({
      error   => [ qw(range) ],
      message => "value is outside allowed range",
      value   => $value,
    });
  }

  if (defined($self->{value}) && $value != $self->{value}) {
    $self->fail({
      error   => [ qw(value) ],
      message => "found value is not the required value",
      value   => $value,
    });
  }

  return 1;
}

sub subname   { 'num' }

1;

__END__

=pod

=encoding UTF-8

=head1 NAME

Data::Rx::CoreType::num - the Rx //num type

=head1 VERSION

version 0.200005

=head1 AUTHOR

Ricardo SIGNES <rjbs@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by Ricardo SIGNES.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
