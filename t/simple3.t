#!/usr/bin/env perl -w
use strict;
use Test::More tests => 1;

use Markapl::FromHTML;
use Perl::Tidy qw(perltidy);

my $html = "<html>
<h1>Hello World</h1>
<p>Hi</p>
</html>";

my $h2m = Markapl::FromHTML->new;

$h2m->load($html);

my ($h1, $h2) = ($h2m->dump, 'sub { html { h1 { "Hello World" } p { "Hi" } } }');

my ($o1, $o2) = ("", "");

perltidy(source => \$h1, destination => \$o1);
perltidy(source => \$h2, destination => \$o2);

is $o1, $o2;


