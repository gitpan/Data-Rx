use strict;
use warnings;
package Data::Rx::CoreType::def;
our $VERSION = '0.100110';
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

version 0.100110

=head1 AUTHOR

  Ricardo SIGNES <rjbs@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2010 by Ricardo SIGNES.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

