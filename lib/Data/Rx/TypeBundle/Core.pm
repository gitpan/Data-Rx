use strict;
use warnings;
package Data::Rx::TypeBundle::Core;
# ABSTRACT: the bundle of core Rx types
$Data::Rx::TypeBundle::Core::VERSION = '0.200006';
use parent 'Data::Rx::TypeBundle';

sub _prefix_pairs {
  return (
    ''      => 'tag:codesimply.com,2008:rx/core/',
    '.meta' => 'tag:codesimply.com,2008:rx/meta/',
  );
}

my @plugins;
sub type_plugins {
  return @plugins if @plugins;

  require Data::Rx::CoreType::all;
  require Data::Rx::CoreType::any;
  require Data::Rx::CoreType::arr;
  require Data::Rx::CoreType::bool;
  require Data::Rx::CoreType::def;
  require Data::Rx::CoreType::fail;
  require Data::Rx::CoreType::int;
  require Data::Rx::CoreType::map;
  require Data::Rx::CoreType::nil;
  require Data::Rx::CoreType::num;
  require Data::Rx::CoreType::one;
  require Data::Rx::CoreType::rec;
  require Data::Rx::CoreType::seq;
  require Data::Rx::CoreType::str;

  return qw(
    Data::Rx::CoreType::all
    Data::Rx::CoreType::any
    Data::Rx::CoreType::arr
    Data::Rx::CoreType::bool
    Data::Rx::CoreType::def
    Data::Rx::CoreType::fail
    Data::Rx::CoreType::int
    Data::Rx::CoreType::map
    Data::Rx::CoreType::nil
    Data::Rx::CoreType::num
    Data::Rx::CoreType::one
    Data::Rx::CoreType::rec
    Data::Rx::CoreType::seq
    Data::Rx::CoreType::str
  );
}

1;

__END__

=pod

=encoding UTF-8

=head1 NAME

Data::Rx::TypeBundle::Core - the bundle of core Rx types

=head1 VERSION

version 0.200006

=head1 AUTHOR

Ricardo SIGNES <rjbs@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2014 by Ricardo SIGNES.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
