use strict;
use warnings;
package Data::Rx::CoreType::seq;
our $VERSION = '0.007';

use base 'Data::Rx::CoreType';
# ABSTRACT: the Rx //seq type

use Scalar::Util ();

sub subname   { 'seq' }

sub new_checker {
  my ($class, $arg, $rx) = @_;
  my $self = $class->SUPER::new_checker({}, $rx);

  Carp::croak("no contents array given")
    unless $arg->{contents} and (ref $arg->{contents} eq 'ARRAY');

  Carp::croak("unknown arguments to new")
    unless Data::Rx::Util->_x_subset_keys_y($arg, {contents=>1,tail=>1});

  my @content_schemata = map { $rx->make_schema($_) }
                         @{ $arg->{contents} };

  $self->{content_schemata} = \@content_schemata;
  $self->{tail_check} = $arg->{tail}
                      ? $rx->make_schema($arg->{tail})
                      : undef;

  return $self;
}

sub check {
  my ($self, $value) = @_;

  return unless
    ! Scalar::Util::blessed($value) and ref $value eq 'ARRAY';

  my $content_schemata = $self->{content_schemata};
  return if @$value < @$content_schemata;
  
  for my $i (0 .. $#$content_schemata) {
    return unless $content_schemata->[ $i ]->check( $value->[ $i ] );
  }

  if ($self->{tail_check} and @$value > @$content_schemata) {
    my $tail = [ @$value[ @$content_schemata..$#$value ] ];
    return unless $self->{tail_check}->check($tail);
  }

  return 1;
}

1;

__END__

=pod

=head1 NAME

Data::Rx::CoreType::seq - the Rx //seq type

=head1 VERSION

version 0.007

=head1 AUTHOR

  Ricardo SIGNES <rjbs@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2009 by Ricardo SIGNES.

This is free software; you can redistribute it and/or modify it under
the same terms as perl itself.

=cut 


