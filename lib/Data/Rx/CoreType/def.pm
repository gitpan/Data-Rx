use strict;
use warnings;
package Data::Rx::CoreType::def;
our $VERSION = '0.006';

use base 'Data::Rx::CoreType';
# ABSTRACT: the Rx //def type

sub check {
  my ($self, $value) = @_;

  return defined $value;
}

sub subname   { 'def' }

1;

__END__

=pod

=head1 NAME

Data::Rx::CoreType::def - the Rx //def type

=head1 VERSION

version 0.006

=head1 AUTHOR

  Ricardo SIGNES <rjbs@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2009 by Ricardo SIGNES.

This is free software; you can redistribute it and/or modify it under
the same terms as perl itself.

=cut 


