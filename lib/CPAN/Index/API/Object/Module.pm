package CPAN::Index::API::Object::Module;
{
  $CPAN::Index::API::Object::Module::VERSION = '0.002';
}

# ABSTRACT: Module entry in 03modlist.data

use strict;
use warnings;

use Carp qw(croak);
use Moose;
use MooseX::Aliases;
use namespace::clean -except => 'meta';

has name => (
    is       => 'ro',
    isa      => 'Str',
    required => 1,
    alias    => 'modid',
);

has author => (
    is       => 'ro',
    isa      => 'Str',
    required => 1,
    alias    => 'userid',
);

has description => (
    is      => 'ro',
    isa     => 'Maybe[Str]',
    default => 'undef',
);

has chapter => (
    is       => 'ro',
    isa      => 'Int',
    required => 0,
    alias    => 'chapterid',
);

has development_stage => (
    is       => 'ro',
    isa      => 'Str',
    required => 0,
    alias    => 'statd',
);

has support_level => (
    is       => 'ro',
    isa      => 'Str',
    required => 0,
    alias    => 'stats',
);

has language_used => (
    is       => 'ro',
    isa      => 'Str',
    required => 0,
    alias    => 'statl',
);

has interface_style => (
    is       => 'ro',
    isa      => 'Str',
    required => 0,
    alias    => 'stati',
);

has public_license => (
    is       => 'ro',
    isa      => 'Str',
    required => 0,
    alias    => 'statp',
);

has dslip => (
    is       => 'ro',
    isa      => 'Str',
    required => 0,
);

# build dslip from individual parameters and vice versa
sub BUILDARGS {
    my ($class, %args) = @_;

    my @entries = qw(
        development_stage
        support_level
        language_used
        interface_style
        public_license
    );

    if ($args{dslip}) {
        my %dslip;
        @dslip{@entries} = split '', $args{dslip};

        foreach my $entry (@entries) {
            if ( exists $args{$entry} and $args{$entry} ne $dslip{$entry} ) {
                croak "You passed an explicit value for '$entry' in the "
                    . "constructor ('$args{$entry}'), but it conflicts "
                    . "with the corresponding value in the 'dslip' parameter "
                    . "('$dslip{$entry}')";
            } else {
                $args{$entry} = $dslip{$entry};
            }
        }
    } else {
        if ( grep { exists $args{$_} } @entries ) {
            foreach my $entry (@entries) {
                $args{dslip} .= $args{$entry};
            }
        }
    }

    return \%args;
}

__PACKAGE__->meta->make_immutable;

__END__
=pod

=head1 NAME

CPAN::Index::API::Object::Module - Module entry in 03modlist.data

=head1 VERSION

version 0.002

=head1 AUTHOR

Peter Shangov <pshangov@yahoo.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2012 by Venda, Inc..

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

