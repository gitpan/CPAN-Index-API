package CPAN::Index::API::Object::Author;
{
  $CPAN::Index::API::Object::Author::VERSION = '0.001';
}

# ABSTRACT: Author entry in 01mailrc

use strict;
use warnings;

use Moose;
use namespace::clean -except => 'meta';

has pauseid => (
    is       => 'ro',
    isa      => 'Str',
    required => 1,
);

has name => (
    is       => 'ro',
    isa      => 'Str',
    required => 1,
);

has email => (
    is       => 'ro',
    isa      => 'Str',
    required => 1,
    default  => 'CENSORED',
);

__PACKAGE__->meta->make_immutable;

__END__
=pod

=head1 NAME

CPAN::Index::API::Object::Author - Author entry in 01mailrc

=head1 VERSION

version 0.001

=head1 AUTHOR

Peter Shangov <pshangov@yahoo.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2012 by Venda, Inc..

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

