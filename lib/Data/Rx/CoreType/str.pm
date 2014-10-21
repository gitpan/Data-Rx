use strict;
use warnings;
package Data::Rx::CoreType::str;
our $VERSION = '0.001';

use base 'Data::Rx::CoreType';
# ABSTRACT: Rx '//str' type

use Data::Rx::Util;

sub new {
  my ($class, $arg, $rx) = @_;
  my $self = {};

  Carp::croak("unknown arguments to new")
    unless Data::Rx::Util->_x_subset_keys_y($arg, { value => 1});

  # XXX: We should be able to reject num values, too. :( -- rjbs, 2008-08-25
  Carp::croak(sprintf 'invalid value for %s', $class->type_name)
    if exists $arg->{value} and (ref $arg->{value} or ! defined $arg->{value});

  $self->{value} = $arg->{value} if defined $arg->{value};

  bless $self => $class;
}

sub check {
  my ($self, $value) = @_;

  return unless defined $value;

  # XXX: This is insufficiently precise.  It's here to keep us from believing
  # that JSON::XS::Boolean objects, which end up looking like 0 or 1, are
  # integers. -- rjbs, 2008-07-24
  return if ref $value;

  return if defined $self->{value} and $self->{value} ne $value;

  # XXX: Really, we need a way to know whether (say) the JSON was one of the
  # following:  { "foo": 1 } or { "foo": "1" }
  # Only one of those is providing a string. -- rjbs, 2008-07-27
  return 1;
}

sub subname   { 'str' }

1;

__END__

=pod

=head1 NAME

Data::Rx::CoreType::str - Rx '//str' type

=head1 VERSION

version 0.001

=head1 AUTHOR

  Ricardo SIGNES <rjbs@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2008 by Ricardo SIGNES.

This is free software; you can redistribute it and/or modify it under
the same terms as perl itself.

=cut 


