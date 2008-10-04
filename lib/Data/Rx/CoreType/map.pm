use strict;
use warnings;
package Data::Rx::CoreType::map;
our $VERSION = '0.004';

use base 'Data::Rx::CoreType';
# ABSTRACT: the Rx //map type

use Scalar::Util ();

sub subname   { 'map' }

sub new_checker {
  my ($class, $arg, $rx) = @_;
  my $self = $class->SUPER::new_checker({}, $rx);

  Carp::croak("unknown arguments to new") unless
  Data::Rx::Util->_x_subset_keys_y($arg, { values => 1 });

  my $content_schema = {};

  Carp::croak("no values constraint given") unless $arg->{values};

  $self->{value_constraint} = $rx->make_schema($arg->{values});

  return $self;
}

sub check {
  my ($self, $value) = @_;

  return unless
    ! Scalar::Util::blessed($value) and ref $value eq 'HASH';

  for my $entry_value (values %$value) {
    return unless $self->{value_constraint}->check($entry_value);
  }

  return 1;
}

1;

__END__

=pod

=head1 NAME

Data::Rx::CoreType::map - the Rx //map type

=head1 VERSION

version 0.004

=head1 AUTHOR

  Ricardo SIGNES <rjbs@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2008 by Ricardo SIGNES.

This is free software; you can redistribute it and/or modify it under
the same terms as perl itself.

=cut 

