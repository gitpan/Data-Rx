use strict;
use warnings;
package Data::Rx::CoreType;
{
  $Data::Rx::CoreType::VERSION = '0.200000'; # TRIAL
}
# ABSTRACT: base class for core Rx types

use Carp ();
use Scalar::Util ();
use Data::Rx::Failure;
use Data::Rx::Failures;

sub new_checker {
  my ($class, $arg, $rx, $type) = @_;
  Carp::croak "$class does not take check arguments" if %$arg;
  bless { type => $type, rx => $rx } => $class;
}

sub type { $_[0]->{type} }

sub rx { $_[0]->{rx} }

sub check {
  my ($self, $value) = @_;
  local $@;

  return 1 if eval { $self->validate($value); };
  my $failures = $@;

  if (eval { $failures->isa('Data::Rx::Failures') }) {
    $self->failure($failures);
    return 0;
  }

  die $failures;
}

sub new_fail {
  my ($self, $struct) = @_;

  $struct->{type} ||= $self->type;

  Data::Rx::Failures->new({
    rx => $self->rx,
    failures => [
      Data::Rx::Failure->new({
        rx     => $self->rx,
        struct => $struct,
      })
    ]
  });
}

sub fail {
  my ($self, $struct) = @_;

  die $self->new_fail($struct);
}

sub failure {
  my $self = shift;

  $self->{failure} = $_[0] if @_;

  return $self->{failure};
}

sub _subchecks {
  my ($self, $subchecks, $fails) = @_;

  my @fails;

  foreach my $subcheck (@$subchecks) {
    if (Scalar::Util::blessed($subcheck)) {
      push @fails, $subcheck;
      next;
    }

    my ($value, $checker, $context) = @$subcheck;

    next if eval { $checker->validate($value) };

    my $failures = $@;
    Carp::confess($failures)
      unless eval { $failures->isa('Data::Rx::Failures') ||
                    $failures->isa('Data::Rx::Failure') };

    $failures->contextualize({
      type  => $self->type,
      %$context,
    });

    push @fails, $failures;
  }

  if (@fails) {
    die Data::Rx::Failures->new( { rx => $self->rx, failures => \@fails } );
  }

  return 1;
}

sub type_uri {
  sprintf 'tag:codesimply.com,2008:rx/core/%s', $_[0]->subname
}

1;

__END__
=pod

=head1 NAME

Data::Rx::CoreType - base class for core Rx types

=head1 VERSION

version 0.200000

=head1 AUTHOR

Ricardo SIGNES <rjbs@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2012 by Ricardo SIGNES.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

