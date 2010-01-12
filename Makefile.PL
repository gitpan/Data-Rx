
use strict;
use warnings;



use ExtUtils::MakeMaker 6.11;



WriteMakefile(
  DISTNAME  => 'Data-Rx',
  NAME      => 'Data::Rx',
  AUTHOR    => "Ricardo\ SIGNES\ \<rjbs\@cpan\.org\>",
  ABSTRACT  => "perl\ implementation\ of\ Rx\ schema\ system",
  VERSION   => '0.100110',
  EXE_FILES => [  ],
  (eval { ExtUtils::MakeMaker->VERSION(6.31) } ? (LICENSE => 'perl') : ()),
  PREREQ_PM    => {
    "Scalar::Util" => '0',
    "Module::Pluggable" => '3.7',
    "File::Find::Rule" => '0',
    "ExtUtils::MakeMaker" => '6.11',
    "Number::Tolerant" => '0',
    "Carp" => '0',
    "List::Util" => '0',
    "Test::More" => '0',
    "autodie" => '0',
    "JSON" => '2',
    "Module::Pluggable::Object" => '0',
  },
  test => {TESTS => 't/*.t'}
);



