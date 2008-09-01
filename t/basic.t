#!/usr/bin/perl

use strict;
use warnings;

use Test::More 'no_plan';

use ok 'Data::Stream::Bulk::Nil';
use ok 'Data::Stream::Bulk::Array';
use ok 'Data::Stream::Bulk::Callback';

{
	my $d = Data::Stream::Bulk::Nil->new;

	ok( $d->is_done, "Nil is always done" );
	ok( !$d->next, "no next block" );
}

{
	my @array = qw(foo bar gorch baz);

	my $d = Data::Stream::Bulk::Array->new( array => \@array );

	ok( !$d->is_done, "not done" );

	is_deeply( $d->next, \@array, "next" );

	ok( $d->is_done, "now it's done" );

	ok( !$d->next, "no next block" );
}

{
	my @array = qw(foo bar gorch baz);

	my $d = Data::Stream::Bulk::Array->new( array => \@array );

	ok( !$d->is_done, "not done" );

	is_deeply( [ $d->items ], \@array, "items method" );

	ok( $d->is_done, "now it's done" );

	ok( !$d->next, "no next block" );
}

{
	my @array = qw(foo bar);

	my $cb = sub { @array && [ shift @array ] };

	my $d = Data::Stream::Bulk::Callback->new( callback => $cb );

	ok( !$d->is_done, "not done" );
	is_deeply( [ $d->items ], [ "foo" ], "items method" );
	ok( !$d->is_done, "not done" );
	is_deeply( [ $d->items ], [ "bar" ], "items method" );
	ok( !$d->is_done, "not done" );
	is_deeply( [ $d->items ], [ ], "items method" );

	ok( $d->is_done, "now it's done" );

	ok( !$d->next, "no next" );
}
