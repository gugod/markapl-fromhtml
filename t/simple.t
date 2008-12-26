#!/usr/bin/env perl -w
use strict;
use Test::More tests => 1;

use Markapl::FromHTML;
use Perl::Tidy qw(perltidy);

my $html = <<HTML;
<h1>Hello World</h1>
<p>I am very good</p>
<div><p>I am very good, too</p></div>
HTML

my $h2m = Markapl::FromHTML->new;

$h2m->load($html);

my ($h1, $h2) = ($h2m->dump, <<MARKAPL);
sub {
h1 { "Hello World" }
p { "I am very good" }
div { p { "I am very good, too" } }
}
MARKAPL

my ($o1, $o2) = ("", "");

perltidy(source => \$h1, destination => \$o1);
perltidy(source => \$h2, destination => \$o2);

is $o1, $o2;

1;

