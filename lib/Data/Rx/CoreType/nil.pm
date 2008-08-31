use strict;
use warnings;
package Data::Rx::CoreType::nil;
our $VERSION = '0.001';

use base 'Data::Rx::CoreType';
# ABSTRACT: Rx '//nil' type

sub check {
  my ($self, $value) = @_;

  return ! defined $value;
}

sub subname   { 'nil' }

1;

__END__

=pod

=head1 NAME

Data::Rx::CoreType::nil - Rx '//nil' type

=head1 VERSION

version 0.001

=head1 AUTHOR

  Ricardo SIGNES <rjbs@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2008 by Ricardo SIGNES.

This is free software; you can redistribute it and/or modify it under
the same terms as perl itself.

=cut 


