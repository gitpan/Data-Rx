use strict;
use warnings;
package Data::Rx::CommonType::EasyNew;
{
  $Data::Rx::CommonType::EasyNew::VERSION = '0.200002';
}
# ABSTRACT: base class for core Rx types, with some defaults
use parent 'Data::Rx::CommonType';

use Carp ();

sub guts_from_arg {
  my ($class, $arg, $rx, $type) = @_;

  Carp::croak "$class does not take check arguments" if %$arg;

  return {};
}

sub new_checker {
  my ($class, $arg, $rx, $type) = @_;

  my $guts = $class->guts_from_arg($arg, $rx, $type);

  # Carp::confess "underscore-led entry in guts!" if grep /\A_/, keys %$guts;
  $guts->{_type} = $type;
  $guts->{_rx}   = $rx;

  bless $guts => $class;
}

sub type { $_[0]->{_type} }

sub rx { $_[0]->{_rx} }

1;

__END__
=pod

=head1 NAME

Data::Rx::CommonType::EasyNew - base class for core Rx types, with some defaults

=head1 VERSION

version 0.200002

=head1 AUTHOR

Ricardo SIGNES <rjbs@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2012 by Ricardo SIGNES.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

