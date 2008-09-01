#!/usr/bin/perl

package Data::Stream::Bulk::Callback;
use Moose;

use namespace::clean -except => 'meta';

with qw(Data::Stream::Bulk::DoneFlag);

has callback => (
	isa => "CodeRef|Str",
	is  => "ro",
	required => 1,
	clearer  => "finished",
);

sub get_more {
	my $self = shift;
	my $cb = $self->callback;
	$self->$cb;
}

__PACKAGE__->meta->make_immutable;

__PACKAGE__

__END__

=pod

=head1 NAME

Data::Stream::Bulk::Callback - Callback based bulk iterator

=head1 SYNOPSIS

	Data::Stream::Bulk::Callback->new(
		callback => sub {
			if ( @more_items = get_some() ) {
				return \@more_items;
			} else {
				return; # done
			}
		},
	}

=head1 DESCRIPTION

This class provides a callback based implementation of L<Data::Stream::Bulk>.

=head1 ATTRIBUTES

=over 4

=item callback

The subroutine that is called when more items are needed.

Should return an array reference for the next block, or a false value if there
is nothing left.

=back

=head1 METHODS

=over 4

=item get_more

See L<Data::Stream::Bulk::DoneFlag>.

Reinvokes C<callback>.

=back

=cut

