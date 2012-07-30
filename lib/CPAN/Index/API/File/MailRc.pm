package CPAN::Index::API::File::MailRc;
{
  $CPAN::Index::API::File::MailRc::VERSION = '0.001';
}

# ABSTRACT: Read and write 01mailrc

use strict;
use warnings;
use Scalar::Util qw(blessed);
use Moose;
with 'CPAN::Index::API::Role::Writer';
with 'CPAN::Index::API::Role::Reader';
use namespace::clean -except => 'meta';

has '+filename' => (
    default => '01mailrc.txt',
);

has '+subdir' => (
    default => 'authors',
);

has authors => (
    is      => 'rw',
    isa     => 'ArrayRef',
    default => sub { [] },
    traits  => ['Array'],
    handles => {
        author_count => 'count',
        author_list  => 'elements',
    },
);

sub sorted_authors {
    my $self = shift;
    return sort { $a->pauseid cmp $b->pauseid } $self->author_list;
}

sub parse {
    my ( $self, $content ) = @_;

    my @authors;

    if ($content)
    {

        foreach my $line ( split "\n", $content ) {
            my ( $alias, $pauseid, $long ) = split ' ', $line, 3;
            $long =~ s/^"//;
            $long =~ s/"$//;
            my ($name, $email) = $long =~ /(.*) <(.+)>$/;
            my $author = CPAN::Index::API::Object::Author->new(
                pauseid => $pauseid,
                name    => $name,
                email   => $email,
            );

            push @authors, $author;
        }
    }

    return ( authors => \@authors );
}

sub default_locations
{
    return ['authors', '01mailrc.txt.gz'];
}

__PACKAGE__->meta->make_immutable;



=pod

=head1 NAME

CPAN::Index::API::File::MailRc - Read and write 01mailrc

=head1 VERSION

version 0.001

=head1 AUTHOR

Peter Shangov <pshangov@yahoo.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2012 by Venda, Inc..

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut


__DATA__
[%
    foreach my $author ($self->sorted_authors) {
        $OUT .= sprintf qq[alias %s "%s <%s>"\n],
            $author->pauseid,
            $author->name,
            $author->email;
    }
%]
