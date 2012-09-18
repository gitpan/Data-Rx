use strict;
use warnings;
package Data::Rx::TypeBundle::Core;
{
  $Data::Rx::TypeBundle::Core::VERSION = '0.200002';
}
use parent 'Data::Rx::TypeBundle';
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

version 0.200002

=head1 AUTHOR

Ricardo SIGNES <rjbs@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2012 by Ricardo SIGNES.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

