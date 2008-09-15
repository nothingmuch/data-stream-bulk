#!/usr/bin/perl

use strict;
use warnings;

use Test::More 'no_plan';

use ok 'Data::Stream::Bulk::Path::Class';

use Path::Class;

my $dist = file(__FILE__)->parent->parent;

foreach my $dir ( $dist->subdir("t"), $dist->subdir("lib"), $dist ) {

	{
		my $paths = Data::Stream::Bulk::Path::Class->new(
			dir => $dir,
			chunk_size => 2,
			max_queue => 3,
			depth_first => 0,
		);

		my $strings = $paths->filter(sub {[ grep { !/tmp/ } map { "$_" } @$_ ]});

		my @rec;
		$dir->recurse( callback => sub { push @rec, "$_[0]" unless $_[0] =~ /tmp/ }, depthfirst => 0, preorder => 1 );

		my @all = $strings->all;

		is_deeply(
			[ sort @all ],
			[ sort @rec ],
			"breadth first traversal path set",
		);

		is_deeply(
			\@all,
			\@rec,
			"breadth first traversal order",
		) || do {
			warn join("\n", @all, "", "");
			warn join("\n", @rec, "", "");
		};
	}

	{
		my $paths = Data::Stream::Bulk::Path::Class->new(
			dir => $dir,
			chunk_size => 2,
			max_queue => 3,
			depth_first => 1,
		);

		my $strings = $paths->filter(sub {[ grep { !/tmp/ } map { "$_" } @$_ ]});

		my @rec;
		$dir->recurse( callback => sub { push @rec, "$_[0]" unless $_[0] =~ /tmp/ }, depthfirst => 1, preorder => 1 );

		my @all = $strings->all;

		is_deeply(
			[ sort @all ],
			[ sort @rec ],
			"depth first traversal path set",
		);

		is_deeply(
			\@all,
			\@rec,
			"depth first traversal order",
		);
	}
}
