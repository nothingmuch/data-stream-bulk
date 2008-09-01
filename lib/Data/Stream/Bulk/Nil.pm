#!/usr/bin/perl

package Data::Stream::Bulk::Nil;
use Moose;

use namespace::clean -except => 'meta';

with qw(Data::Stream::Bulk);

sub next { undef }

sub is_done { 1 }

__PACKAGE__->meta->make_immutable;

__PACKAGE__

__END__

=pod

=head1 NAME

Data::Stream::Bulk::Nil - An empty L<Data::Stream::Bulk> iterator

=head1 SYNOPSIS

	return Data::Stream::Bulk::Nil->new; # empty set

=head1 DESCRIPTION

This iterator can be used to return the empty resultset.

=head1 METHODS

=over 4

=item is_done

Always returns true.

=item next

Always returns undef.

=back

=cut

