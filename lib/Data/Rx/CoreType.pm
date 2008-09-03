use strict;
use warnings;
package Data::Rx::CoreType;
our $VERSION = '0.002';

# ABSTRACT: base class for core Rx types

sub new {
  my ($class, $arg, $rx) = @_;
  Carp::croak "$class does not take check arguments" if %$arg;
  bless { rx => $rx } => $class;
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

version 0.002

=head1 AUTHOR

  Ricardo SIGNES <rjbs@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2008 by Ricardo SIGNES.

This is free software; you can redistribute it and/or modify it under
the same terms as perl itself.

=cut 


