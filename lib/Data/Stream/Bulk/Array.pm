#!/usr/bin/perl

package Data::Stream::Bulk::Array;
use Moose;

use namespace::clean -except => 'meta';

with qw(Data::Stream::Bulk);

has array => (
	isa => "ArrayRef",
	reader  => "_array",
	clearer => "_clear_array",
	predicate => "_has_array",
	required => 1,
);

sub is_done {
	my $self = shift;
	!$self->_has_array;
}

sub next {
	my $self = shift;

	if ( my $array = $self->_array ) {
		$self->_clear_array;
		return $array;
	} else {
		return;
	}
}

__PACKAGE__->meta->make_immutable;

__PACKAGE__

__END__

=pod

=head1 NAME

Data::Stream::Bulk::Array - L<Data::Stream::Bulk> wrapper for simple arrays.

=head1 SYNOPSIS

	return Data::Stream::Bulk::Array->new(
		array => \@results,
	);

=head1 DESCRIPTION

This implementation of the L<Data::Stream::Bulk> api wraps an array.

The use case is to keep the consumer of the data set implementation agnostic so
that it can deal with larger data sets if they are encountered, but still
retain most of the simplicity when the current data set easily fits in memory.

=head1 ATTRIBUTES

=over 4

=item array

The array reference to wrap.

=back

=head1 METHODS

=over 4

=item next

Returns the array reference on the first invocation, and nothing thereafter.

=item is_done

Returns true if C<next> has been called.

=back

=cut
