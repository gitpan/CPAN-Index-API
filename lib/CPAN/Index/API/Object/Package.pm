package CPAN::Index::API::Object::Package;
{
  $CPAN::Index::API::Object::Package::VERSION = '0.002';
}

# ABSTRACT: Package entry in 02packages.details

use strict;
use warnings;

use Moose;
use namespace::clean -except => 'meta';

has name => (
    is       => 'rw',
    isa      => 'Str',
    required => 1,
);

has version => (
    is      => 'rw',
    isa     => 'Maybe[Str]',
    default => 'undef',
);

has distribution => (
    is       => 'rw',
    isa      => 'Str',
    required => 1,
);

__PACKAGE__->meta->make_immutable;

__END__
=pod

=head1 NAME

CPAN::Index::API::Object::Package - Package entry in 02packages.details

=head1 VERSION

version 0.002

=head1 AUTHOR

Peter Shangov <pshangov@yahoo.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2012 by Venda, Inc..

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

