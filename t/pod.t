use strict;
use warnings;
use Test::More;

plan skip_all => 'set TEST_POD to enable this test'
    unless $ENV{TEST_POD};

eval "use Test::Pod";
plan skip_all => 'Test::Pod required for this test'
    if $@;

all_pod_files_ok();
