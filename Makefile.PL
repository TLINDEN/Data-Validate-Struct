#
# Makefile.PL - build file for Date::Validate::Struct
#
# Copyright (c) 2007-2013 Thomas Linden <tom |AT| cpan.org>.
# All Rights Reserved. Std. disclaimer applies.
# Artificial License, same as perl itself. Have fun.
#

use ExtUtils::MakeMaker;

WriteMakefile(
	      NAME	   => 'Data::Validate::Struct',
	      VERSION_FROM => 'Struct.pm',
	      clean        => { FILES => '*~ */*~' },
	      PREREQ_PM    => { 
                'Regexp::Common' => 0,
                'Data::Validate' => '0.06',
                'Data::Validate::IP' => '0.18',
              },
	      dist         => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
	      test         => { TESTS => 't/*.t' }
);

