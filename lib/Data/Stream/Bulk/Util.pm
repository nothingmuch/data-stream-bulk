#!/usr/bin/perl

package Data::Stream::Bulk::Util;

use strict;
use warnings;

use Data::Stream::Bulk::Nil;
use Data::Stream::Bulk::Array;

use namespace::clean;

use Sub::Exporter -setup => {
	exports => [qw(nil bulk cat)],
};

sub nil () { Data::Stream::Bulk::Nil->new }

sub bulk (@) { return @_ ? Data::Stream::Bulk::Array->new( array => [ @_ ] ) : nil }

sub cat (@) { return @_ ? shift->cat(@_) : nil }

__PACKAGE__

__END__

=pod

=head1 NAME

Data::Stream::Bulk::Util - Utility functions for L<Data::Stream::Bulk::Util>

=head1 SYNOPSIS

	use Data::Stream::Bulk::Util qw(array);

	use namespace::clean;

	# Wrap a list in L<Data::Stream::Bulk::Array>
	return bulk(qw(foo bar gorch baz));

	# return an empty resultset
	return nil();

=head1 DESCRIPTION

This module exports convenience functions for use with L<Data::Stream::Bulk>.

=head1 EXPORTS

L<Sub::Exporter> is used to create the C<import> routine, and all of its
aliasing/currying goodness is of course supported.

=over 4

=item nil

Creates a new L<Data::Stream::Bulk::Nil> object.

Takes no arguments.

=item bulk @items

Creates a new L<Data::Stream::Bulk::Array> wrapping C<@items>.

=item cat @streams

Concatenate several streams together.

Returns C<nil> if no arguments are provided.

=back

=cut

