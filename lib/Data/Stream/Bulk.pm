#!/usr/bin/perl

package Data::Stream::Bulk;
use Moose::Role;

use namespace::clean -except => 'meta';

our $VERSION = "0.01";

requires qw(next is_done);

sub items {
	my $self = shift;

	if ( my $a = $self->next ) {
		return @$a;
	} else {
		return ();
	}
}

sub all {
	my $self = shift;

	my @ret;

	while ( my $next = $self->next ) {
		push @ret, @$next;
	}

	return @ret;
}

__PACKAGE__

__END__

=pod

=head1 NAME

Data::Stream::Bulk - N at a time iteration api

=head1 SYNOPSIS

	# get a bulk stream from somewere
	my $s = Data::Stream::Bulk::Foo->new( ... );

	# can be used like this:
	until ( $s->is_done ) {
		foreach my $item ( $s->items ) {
			process($item);
		}
	}

	# or like this:
	while( my $block = $s->next ) {
		foreach my $item ( @$block ) {
			process($item);
		}
	}

=head1 DESCRIPTION

This module tries to find middle ground between one at a time and all at once
processing of data sets.

The purpose of this module is to avoid the overhead of implementing an
iterative api when this isn't necessary, without breaking forward
compatibility in case that becomes necessary later on.

The API optimizes for when a data set typically fits in memory and is returned
as an array, but the consumer cannot assume that the data set is bounded.

The API is destructive in order to minimize the chance that resultsets are
leaked due to improper usage.

=head1 API

=head2 Required Methods

The API requires two methods to be implemented:

=over 4

=item is_done

Should return true if the stream is exhausted.

As long as this method returns a false value (not done) C<next> could
potentially return another block.

=item next

Returns the next block.

Note that C<next> is not guaranteed to return an array reference, even if
C<is_done> returned false prior to calling it.

=back

=head2 Convenience Methods

=over 4

=item items

This method calls C<next> and dereferences the result if there are pending
items.

=item all

Force evaluation of the entire resultset.

Note that for large data sets this might cause swap thrashing of various other
undesired effects. Use with caution.

=back

=head1 CLASSES

=over 4

=item L<Data::Stream::Bulk::Array>

This class is not a stream at all, but just one block. When the data set easily
fits in memory this class can be used, while retaining forward compatibility
with larger data sets.

=item L<Data::Stream::Bulk::Callback>

Callback driven iteration.

=item L<Data::Stream::Bulk::DBI>

Bulk fetching of data from L<DBI> statement handles.

=item L<Data::Stream::Bulk::DBIC>

L<DBIx::Class::ResultSet> iteration.

=item L<Data::Stream::Bulk::Nil>

An empty result set.

=back

=back

=head1 VERSION CONTROL

This module is maintained using Darcs. You can get the latest version from
L<http://nothingmuch.woobling.org/code>, and use C<darcs send> to commit
changes.

=head1 AUTHOR

Yuval Kogman E<lt>nothingmuch@woobling.orgE<gt>

=head1 COPYRIGHT

	Copyright (c) 2008 Yuval Kogman. All rights reserved
	This program is free software; you can redistribute
	it and/or modify it under the same terms as Perl itself.

=cut

