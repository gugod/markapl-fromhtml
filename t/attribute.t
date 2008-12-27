#!/usr/bin/env perl -w
use strict;
use Test::More tests => 1;

use Markapl::FromHTML;
use Perl::Tidy qw(perltidy);

my $html = "<html><h1 class=\"title\">Hello World</h1></html>";

my $h2m = Markapl::FromHTML->new;

$h2m->load($html);

my ($h1, $h2) = ($h2m->dump, qq{sub {\nhtml { h1( class => "title" ) { "Hello World" } }\n}\n});

is $h1, $h2;

# my ($o1, $o2) = ("", "");
# perltidy(source => \$h1, destination => \$o1);
# perltidy(source => \$h2, destination => \$o2);
# is $o1, $o2;


