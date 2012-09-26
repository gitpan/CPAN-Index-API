package CPAN::Index::API::File;
{
  $CPAN::Index::API::File::VERSION = '0.004';
}

# ABSTRACT: Base class for index file objects

use Moose;

sub clone
{
    my ($self, %params) = @_;
    $self->meta->clone_object($self, %params);
}

__PACKAGE__->meta->make_immutable;


__END__
=pod

=head1 NAME

CPAN::Index::API::File - Base class for index file objects

=head1 VERSION

version 0.004

=head1 DESCRIPTION

All index file implementations should inherit from this class.

=head1 PROVIDES

=head2 clone

Clones the object. See L<Class::MOP::Class/clone> for details.

=head1 AUTHOR

Peter Shangov <pshangov@yahoo.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2012 by Venda, Inc..

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

