use strict;
use warnings;
package Data::Rx::Failure;
{
  $Data::Rx::Failure::VERSION = '0.200002';
}
# ABSTRACT: structured failure report from an Rx checker


use overload '""' => \&stringify;

sub new {
  my ($class, $arg) = @_;

  my $guts = {
    rx => $arg->{rx},
    struct => [ $arg->{struct} ],
  };

  bless $guts => $class;
}

sub struct { $_[0]->{struct} }

sub contextualize {
  my ($self, $struct) = @_;

  push @{ $self->struct }, $struct;

  if (my $failures = $self->struct->[0]{failures}) {
    $_->contextualize($struct) foreach @$failures;
  }

  return $self;
}

sub value {
  my ($self) = @_;

  return $self->struct->[0]{value};
}

sub error_types {
  my ($self) = @_;

  return @{ $self->struct->[0]{error} };
}

sub error_string {
  my ($self) = @_;

  join ', ', $self->error_types;
}

sub keys {
  my ($self) = @_;

  return @{ $self->struct->[0]{keys} || [] };
}

sub size {
  my ($self) = @_;

  return $self->struct->[0]{size};
}

sub data_path {
  my ($self) = @_;

  map {; map { $_->[0] } @{ $_->{data_path} || [] } }
    reverse @{ $self->struct };
}

sub data_string {
  my ($self) = @_;

  return $self->_path_string('$data', 'data_path');
}

sub check_path {
  my ($self) = @_;

  map {; map { $_->[0] } @{ $_->{check_path} || [] } }
    reverse @{ $self->struct };
}

sub check_string {
  my ($self) = @_;

  return $self->_path_string('$schema', 'check_path');
}

sub _path_string {
  my ($self, $base, $key) = @_;

  my $str  = $base;

  for my $frame (reverse @{ $self->struct || [] }) {
    my $hunk = $frame->{ $key };
    for my $entry (@$hunk) {
      if    ($entry->[1] eq 'key')   { $str .= "->{$entry->[0]}"; }
      elsif ($entry->[1] eq 'index') { $str .= "->[$entry->[0]]"; }
      elsif ($entry->[2])            { $str = $entry->[2]->($str, @$entry) }
      else                           { $str .= "->? $entry->[0] ?"; }
    }
  }

  return $str;
}

sub stringify {
  my ($self) = @_;

  my $struct = $self->struct;

  my $str = sprintf "Failed %s: %s (error: %s at %s)",
    $self->error_types,
    $struct->[0]{message},
    $self->error_string,
    $self->data_string;

  # also stringify failures under the current failure (as for //any),
  # with indentation
  if (my $failures = $struct->[0]{failures}) {
    foreach my $fail (@$failures) {
      my $tmp = "$fail";
      $tmp =~ s/\A/  - /;
      $tmp =~ s/(?<=\n)^/    /mg;
      $str .= "\n$tmp";
    }
  }

  return $str;
}

1;

__END__
=pod

=head1 NAME

Data::Rx::Failure - structured failure report from an Rx checker

=head1 VERSION

version 0.200002

=head1 AUTHOR

Ricardo SIGNES <rjbs@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2012 by Ricardo SIGNES.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

