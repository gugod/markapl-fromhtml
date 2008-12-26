use strict;
use warnings;
use inc::Module::Install;

all_from 'lib/Markapl/FromHTML.pm';

build_requires  'Test::More'        => '0.42';

WriteAll;


