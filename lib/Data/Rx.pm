use strict;
use warnings;
package Data::Rx;
our $VERSION = '0.007';

# ABSTRACT: perl implementation of Rx schema system

use Data::Rx::Util;
use Data::Rx::TypeBundle::Core;


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

  my @plugins = @{ $arg->{type_plugins} || [] };
  unshift @plugins, $class->core_bundle unless $arg->{no_core_bundle};

  my $self = {
    prefix  => { },
    handler => { },
  };

  bless $self => $class;

  $self->register_type_plugin($_) for @plugins;

  $self->add_prefix($_ => $arg->{prefix}{ $_ }) for keys %{ $arg->{prefix} };

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
  my ($self, $starting_plugin) = @_;

  my @plugins = ($starting_plugin);
  PLUGIN: while (my $plugin = shift @plugins) {
    if ($plugin->isa('Data::Rx::TypeBundle')) {
      my %pairs = $plugin->prefix_pairs;
      $self->add_prefix($_ => $pairs{ $_ }) for keys %pairs;

      unshift @plugins, $plugin->type_plugins;
    } else {
      my $uri = $plugin->type_uri;

      Carp::confess("a type plugin is already registered for $uri")
        if $self->{handler}{ $uri };
        
      $self->{handler}{ $uri } = $plugin;
    }
  }
}


sub add_prefix {
  my ($self, $name, $base) = @_;

  Carp::confess("the prefix $name is already registered")
    if $self->{prefix}{ $name };

  $self->{prefix}{ $name } = $base;
}

sub core_bundle {
  return 'Data::Rx::TypeBundle::Core';
}

sub core_type_plugins { 
  my ($self) = @_;

  Carp::cluck("core_type_plugins deprecated; use Data::Rx::TypeBundle::Core");

  Data::Rx::TypeBundle::Core->type_plugins;
}

1;

__END__

=pod

=head1 NAME

Data::Rx - perl implementation of Rx schema system

=head1 VERSION

version 0.007

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

    prefix        - optional; a hashref of prefix pairs for type shorthand
    type_plugins  - optional; an arrayref of type or type bundle plugins
    no_core_types - optional; if true, core type bundle is not loaded

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

    $rx->register_type_plugin($type_or_bundle);

Given a type plugin, this registers the plugin with the Data::Rx object.
Bundles are expanded recursively and all their plugins are registered.
Type plugins must have a C<type_uri> method and a C<new_checker> method.

=head2 add_prefix

    $rx->add_prefix($name => $prefix_string);

For example:

    $rx->add_prefix('.meta' => 'tag:codesimply.com,2008:rx/meta/');

=head1 AUTHOR

  Ricardo SIGNES <rjbs@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2009 by Ricardo SIGNES.

This is free software; you can redistribute it and/or modify it under
the same terms as perl itself.

=cut 


