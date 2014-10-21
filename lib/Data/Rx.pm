use strict;
use warnings;
package Data::Rx;
our $VERSION = '0.003';

# ABSTRACT: perl implementation of Rx schema system

use Data::Rx::Util;
use Module::Pluggable::Object;


sub __built_in_prefixes {
  return (
    ''      => 'tag:codesimply.com,2008:rx/core/',
    '.meta' => 'tag:codesimply.com,2008:rx/meta/',
  );
}

sub _expand_uri {
  my ($self, $str) = @_;
  return $str if $str =~ /\A\w+:/;

  if ($str =~ m{\A/(.*?)/(.+)\z}) {
    my ($prefix, $rest) = ($1, $2);
  
    my $lookup = $self->{prefix};
    Carp::croak "unknown prefix '$prefix' in type name '$str'"
      unless exists $lookup->{$prefix};

    return "$lookup->{$prefix}$rest";
  }

  Carp::croak "couldn't understand Rx type name '$str'";
}


sub new {
  my ($class, $arg) = @_;
  $arg ||= {};
  $arg->{prefix} ||= {};

  my $self = {
    prefix  => {
      $class->__built_in_prefixes,
      %{ $arg->{prefix} },
    },
    handler => {},
  };

  bless $self => $class;

  my @plugins = $self->core_type_plugins;

  $self->register_type_plugin($_) for @plugins;

  if ($arg->{plugins}) {
    $self->register_type_plugin($_) for @{ $arg->{plugins} };
  }

  return $self;
}


sub make_schema {
  my ($self, $schema) = @_;

  $schema = { type => "$schema" } unless ref $schema;

  Carp::croak("no type name given") unless my $type = $schema->{type};

  my $type_uri = $self->_expand_uri($type);
  die "unknown type uri: $type_uri" unless exists $self->{handler}{$type_uri};

  my $handler = $self->{handler}{$type_uri};

  my $schema_arg = {%$schema};
  delete $schema_arg->{type};
  my $checker = $handler->new_checker($schema_arg, $self);

  return $checker;
}


sub register_type_plugin {
  my ($self, $plugin) = @_;

  $self->{handler}{ $plugin->type_uri } = $plugin;
}


sub core_type_plugins { 
  my ($self) = @_;

  my $mpo = Module::Pluggable::Object->new(
    search_path => 'Data::Rx::CoreType',
    require     => 1,
  );

  my @plugins = $mpo->plugins;
}

1;

__END__

=pod

=head1 NAME

Data::Rx - perl implementation of Rx schema system

=head1 VERSION

version 0.003

=head1 SYNOPSIS

    my $rx = Data::Rx->new;

    my $success = {
      type     => '//rec',
      required => {
        location => '//str',
        status   => { type => '//int', value => 201 },
      },
      optional => {
        comments => {
          type     => '//arr',
          contents => '//str',
        },
      },
    };

    my $schema = $rx->make_schema($success);

    my $reply = $json->decode( $agent->get($http_request) );

    die "invalid reply" unless $schema->check($reply);

=head1 SEE ALSO

L<http://rjbs.manxome.org/rx>

=head1 METHODS

=head2 new

    my $rx = Data::Rx->new(\%arg);

This returns a new Data::Rx object.

Valid arguments are:

    prefix - optional; a hashref of prefix strings and values for type shorthand

The prefix hashref should look something like this:

    {
      'pobox'  => 'tag:pobox.com,1995:rx/core/',
      'skynet' => 'tag:skynet.mil,1997-08-29:types/rx/',
    }

=head2 make_schema

    my $schema = $rx->make_schema($schema);

This returns a new schema checker (something with a C<check> method) for the
given Rx input.

=head2 register_type_plugin

    $rx->register_type_plugin($plugin);

Given a type plugin, this registers the plugin with the Data::Rx object.
Plugins must have a C<type_uri> method and a C<new_checker> method.

=head2 core_type_plugins {

This method returns a list of the plugins for the core Rx types.

=head1 AUTHOR

  Ricardo SIGNES <rjbs@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2008 by Ricardo SIGNES.

This is free software; you can redistribute it and/or modify it under
the same terms as perl itself.

=cut 


