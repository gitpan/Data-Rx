use strict;
use warnings;
package Data::Rx::CoreType::rec;
our $VERSION = '0.100110';
use base 'Data::Rx::CoreType';
# ABSTRACT: the Rx //rec type

use Scalar::Util ();

sub subname   { 'rec' }

sub new_checker {
  my ($class, $arg, $rx) = @_;
  my $self = $class->SUPER::new_checker({}, $rx);

  Carp::croak("unknown arguments to new") unless
  Data::Rx::Util->_x_subset_keys_y($arg, {
    rest     => 1,
    required => 1,
    optional => 1,
  });

  my $content_schema = {};

  $self->{rest_schema} = $rx->make_schema($arg->{rest}) if $arg->{rest};

  TYPE: for my $type (qw(required optional)) {
    next TYPE unless my $entries = $arg->{$type};

    for my $entry (keys %$entries) {
      Carp::croak("$entry appears in both required and optional")
        if $content_schema->{ $entry };

      $content_schema->{ $entry } = {
        optional => $type eq 'optional',
        schema   => $rx->make_schema($entries->{ $entry }),
      };
    }
  };

  $self->{content_schema} = $content_schema;
  return $self;
}

sub check {
  my ($self, $value) = @_;

  return unless
    ! Scalar::Util::blessed($value) and ref $value eq 'HASH';

  my $c_schema = $self->{content_schema};

  my @rest_keys = grep { ! exists $c_schema->{$_} } keys %$value;
  return if @rest_keys and not $self->{rest_schema};

  for my $key (keys %$c_schema) {
    my $check = $c_schema->{$key};
    return if not $check->{optional} and not exists $value->{$key};
    return if exists $value->{$key} and ! $check->{schema}->check($value->{$key});
  }

  if (@rest_keys) {
    my %rest = map { $_ => $value->{$_} } @rest_keys;
    return unless $self->{rest_schema}->check(\%rest);
  }

  return 1;
}

1;

__END__
=pod

=head1 NAME

Data::Rx::CoreType::rec - the Rx //rec type

=head1 VERSION

version 0.100110

=head1 AUTHOR

  Ricardo SIGNES <rjbs@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2010 by Ricardo SIGNES.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

