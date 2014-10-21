use strict;
use warnings;
package Data::Rx::CoreType::all;
{
  $Data::Rx::CoreType::all::VERSION = '0.200002';
}
use parent 'Data::Rx::CoreType';
# ABSTRACT: the Rx //all type

use Scalar::Util ();

sub guts_from_arg {
  my ($class, $arg, $rx, $type) = @_;

  Carp::croak("unknown arguments to new")
    unless Data::Rx::Util->_x_subset_keys_y($arg, { of  => 1});

  Carp::croak("no 'of' parameter given to //all") unless exists $arg->{of};

  my $of = $arg->{of};

  Carp::croak("invalid 'of' argument to //all") unless
    defined $of and Scalar::Util::reftype $of eq 'ARRAY' and @$of;

  return { of => [ map {; $rx->make_schema($_) } @$of ] };
}

sub assert_valid {
  my ($self, $value) = @_;

  my @subchecks;
  for my $i (0 .. $#{ $self->{of} }) {
    push @subchecks, [
      $value,
      $self->{of}[$i],
      {
        check_path => [ [ 'of', 'key'], [ $i, 'index' ] ],
      }
    ];
  }

  $self->perform_subchecks(\@subchecks);

  return 1;
}

sub subname   { 'all' }

1;

__END__
=pod

=head1 NAME

Data::Rx::CoreType::all - the Rx //all type

=head1 VERSION

version 0.200002

=head1 AUTHOR

Ricardo SIGNES <rjbs@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2012 by Ricardo SIGNES.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

