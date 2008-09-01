#!/usr/bin/perl

package Data::Stream::Bulk::Cat;
use Moose;

use namespace::clean -except => 'meta';

with qw(Data::Stream::Bulk);

has streams => (
	isa => "ArrayRef[Data::Stream::Bulk]",
	is  => "ro",
	required => 1,
);

sub is_done {
	my $self = shift;
	@{ $self->streams } == 0;
}

sub next {
	my $self = shift;

	my $s = $self->streams;

	return unless @$s;

	my $next;

	until ( $next = @$s && $s->[0]->next ) {
		shift @$s;
		return unless @$s;
	}

	return $next;
}

sub list_cat {
	my ( $self, @rest ) = @_;
	my ( $head, @tail ) = ( @{ $self->streams }, @rest );
	return () unless $head;
	return $head->list_cat(@tail);
}

__PACKAGE__->meta->make_immutable;

__PACKAGE__

__END__

=pod

=head1 NAME

Data::Stream::Bulk::Cat - Concatenated streams

=head1 SYNOPSIS

	use Data::Stream::Bulk::Cat;

	Data::Stream::Bulk::Cat->new(
		streams => [ $s1, $s2, $s3 ],
	);

=head1 DESCRIPTION

This stream is a concatenation of several other streams.

=head1 METHODS

=over 4

=item is_done

Returns true if the list of streams is empty.

=item next

Returns the next block from the next ready stream.

=item list_cat

Breaks down the internal list of streams, and delegates C<list_cat> to the
first one.

Has the effect of inlining the nested streams into the total concatenation,
allowing L<Data::Stream::Bulk::Array/list_cat> to work better.

=back

=cut


