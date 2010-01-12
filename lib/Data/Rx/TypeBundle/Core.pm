use strict;
use warnings;
package Data::Rx::TypeBundle::Core;
our $VERSION = '0.100110';
use base 'Data::Rx::TypeBundle';
# ABSTRACT: the bundle of core Rx types

use Module::Pluggable::Object;

sub _prefix_pairs {
  return (
    ''      => 'tag:codesimply.com,2008:rx/core/',
    '.meta' => 'tag:codesimply.com,2008:rx/meta/',
  );
}

my @plugins;
sub type_plugins {
  return @plugins if @plugins;

  my $mpo = Module::Pluggable::Object->new(
    search_path => 'Data::Rx::CoreType',
    require     => 1,
  );

  return @plugins = $mpo->plugins;
}

1;

__END__
=pod

=head1 NAME

Data::Rx::TypeBundle::Core - the bundle of core Rx types

=head1 VERSION

version 0.100110

=head1 AUTHOR

  Ricardo SIGNES <rjbs@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2010 by Ricardo SIGNES.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

