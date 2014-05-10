#!perl -T
use 5.006;
use strict;
use warnings FATAL => 'all';
use Test::More;

plan tests => 1;

BEGIN {
    use_ok( 'Devel::EvalsRunning' ) || print "Bail out!\n";
}

diag( "Testing Devel::EvalsRunning $Devel::EvalsRunning::VERSION, Perl $], $^X" );
