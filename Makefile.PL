
use strict;
use warnings;



use ExtUtils::MakeMaker 6.30;



my %WriteMakefileArgs = (
  "ABSTRACT" => "perl implementation of Rx schema system",
  "AUTHOR" => "Ricardo SIGNES <rjbs\@cpan.org>",
  "BUILD_REQUIRES" => {
    "File::Find::Rule" => 0,
    "JSON" => 0,
    "Test::Deep::NoTest" => 0,
    "Test::More" => "0.96",
    "Try::Tiny" => 0,
    "autodie" => 0
  },
  "CONFIGURE_REQUIRES" => {
    "ExtUtils::MakeMaker" => "6.30"
  },
  "DISTNAME" => "Data-Rx",
  "EXE_FILES" => [],
  "LICENSE" => "perl",
  "NAME" => "Data::Rx",
  "PREREQ_PM" => {
    "Carp" => 0,
    "File::Find::Rule" => 0,
    "JSON" => 2,
    "List::Util" => 0,
    "Module::Pluggable" => "3.7",
    "Module::Pluggable::Object" => 0,
    "Number::Tolerant" => 0,
    "Scalar::Util" => 0,
    "Test::More" => 0,
    "autodie" => 0,
    "base" => 0,
    "overload" => 0,
    "strict" => 0,
    "warnings" => 0
  },
  "VERSION" => "0.200000",
  "test" => {
    "TESTS" => "t/*.t"
  }
);


unless ( eval { ExtUtils::MakeMaker->VERSION(6.56) } ) {
  my $br = delete $WriteMakefileArgs{BUILD_REQUIRES};
  my $pp = $WriteMakefileArgs{PREREQ_PM};
  for my $mod ( keys %$br ) {
    if ( exists $pp->{$mod} ) {
      $pp->{$mod} = $br->{$mod} if $br->{$mod} > $pp->{$mod};
    }
    else {
      $pp->{$mod} = $br->{$mod};
    }
  }
}

delete $WriteMakefileArgs{CONFIGURE_REQUIRES}
  unless eval { ExtUtils::MakeMaker->VERSION(6.52) };

WriteMakefile(%WriteMakefileArgs);



