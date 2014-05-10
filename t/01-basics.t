#!perl
use 5.008;
use strict;
use warnings FATAL => 'all';
use Test::More;

use blib;
use Devel::EvalsRunning qw(evals_running);

is(
    ${^EVALS_RUNNING},
    0,
    '${^EVALS_RUNNING} is 0 outside of an eval'
);

my $running = eval { ${^EVALS_RUNNING} };
ok($running, 'eval { ${^EVALS_RUNNING} } works');

my $running_func = eval { evals_running() };
is($running, $running_func, "evals_running() works");

is(
    eval '${^EVALS_RUNNING}',
    1,
    '${^EVALS_RUNNING} works with eval STRING'
);

is(
    eval { eval {       ${^EVALS_RUNNING}  } },
    2,
);

is(
    eval { eval { eval '${^EVALS_RUNNING}' } },
    3,
);

my $i = 1000;
my $x = 'eval { ' x $i . '${^EVALS_RUNNING}' . '}' x $i;
my $ret = eval $x;
is(
    $ret,
    $i+1,
    "works with deeply nested eval {}"
);

sub foo {
    my ($i) = @_;
    if ( $i ) {
        return eval { foo(--$i) };
    }
    else {
        return ${^EVALS_RUNNING};
    }
}

is(
    foo(50),
    50,
    "Works with recursion"
);

done_testing;
