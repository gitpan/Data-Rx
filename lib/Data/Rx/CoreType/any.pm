use strict;
use warnings;
package Data::Rx::CoreType::any;
our $VERSION = '0.006';

use base 'Data::Rx::CoreType';
# ABSTRACT: the Rx //any type

use Scalar::Util ();

sub new_checker {
  my ($class, $arg, $rx) = @_;

  Carp::croak("unknown arguments to new")
    unless Data::Rx::Util->_x_subset_keys_y($arg, { of  => 1});

  my $self = bless { } => $class;

  if (my $of = $arg->{of}) {
    Carp::croak("invalid 'of' argument to //any") unless
      Scalar::Util::reftype $of eq 'ARRAY' and @$of;
    
    $self->{of} = [ map {; $rx->make_schema($_) } @$of ];
  }

  return $self;
}

sub check {
  return 1 unless $_[0]->{of};

  my ($self, $value) = @_;
  
  $_->check($value) && return 1 for @{ $self->{of} };
  return;
}

sub subname   { 'any' }

1;

__END__

=pod

=head1 NAME

Data::Rx::CoreType::any - the Rx //any type

=head1 VERSION

version 0.006

=head1 AUTHOR

  Ricardo SIGNES <rjbs@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2009 by Ricardo SIGNES.

This is free software; you can redistribute it and/or modify it under
the same terms as perl itself.

=cut 


