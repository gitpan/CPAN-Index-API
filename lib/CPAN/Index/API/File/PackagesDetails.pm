package CPAN::Index::API::File::PackagesDetails;
{
  $CPAN::Index::API::File::PackagesDetails::VERSION = '0.004';
}

# ABSTRACT: Write 02packages.details

use strict;
use warnings;

use URI;
use URI::file;
use Path::Class qw(file dir);
use Carp        qw(croak);
use List::Util  qw(first);
use namespace::autoclean;
use Moose;

extends qw(CPAN::Index::API::File);
with qw(CPAN::Index::API::Role::Writer CPAN::Index::API::Role::Reader);

has filename => (
    is         => 'ro',
    isa        => 'Str',
    required   => 1,
    lazy_build => 1,
);

has uri => (
    is         => 'ro',
    isa        => 'Str',
    required   => 1,
    lazy_build => 1,
);

has repo_uri => (
    is  => 'ro',
    isa => 'Str',
);

has description => (
    is       => 'ro',
    isa      => 'Str',
    required => 1,
    default  => 'Package names found in directory $CPAN/authors/id/',
);

has columns => (
    is       => 'ro',
    isa      => 'Str',
    required => 1,
    default  => 'package name, version, path',
);

has intended_for => (
    is       => 'ro',
    isa      => 'Str',
    required => 1,
    default  => 'Automated fetch routines, namespace documentation.',
);

has written_by => (
    is       => 'ro',
    isa      => 'Str',
    required => 1,
    default  => "CPAN::Index::API::File::PackagesDetails $CPAN::Index::API::File::PackagesDetails::VERSION",
);

has last_updated => (
    is       => 'ro',
    isa      => 'Str',
    required => 1,
    lazy     => 1,
    default  => sub { scalar gmtime() . " GMT" },
);

has packages => (
    is      => 'bare',
    isa     => 'ArrayRef[HashRef]',
    default => sub { [] },
    traits  => ['Array'],
    handles => {
        package_count => 'count',
        packages      => 'elements',
        add_package   => 'push',
    },
);

sub BUILDARGS {
    my ( $class, %args ) = @_;

    if ( $args{uri} or $args{repo_uri} )
    {
        return \%args;
    }
    elsif ($args{repo_path})
    {
        $args{repo_uri} = URI::file->new(
            dir($args{repo_path})->absolute,
        )->as_string;

        return \%args;
    }
    else
    {
        croak "Either 'uri', 'repo_uri' or 'repo_path' is required";
    }
}

sub _build_filename {
    my $self = shift;
    return file($self->default_location)->basename;
}

sub _build_uri {
    my $self = shift;
    my $uri = URI->new($self->repo_uri);
    $uri->path_segments(
        grep { $_ ne '' } $uri->path_segments,
        file($self->default_location)->dir->dir_list,
        file($self->default_location)->basename,
    );
    return $uri->as_string;
}

sub package
{
    my ($self, $name) = @_;
    return first { $_->{name} eq $name } $self->packages;
}

sub sorted_packages
{
    my $self = shift;
    return sort { $a->{name} cmp $b->{name} } $self->packages;
}

sub parse {
    my ( $self, $content ) = @_;

    my %map = (
        'File'         => 'file',
        'URL'          => 'uri',
        'Description'  => 'description',
        'Columns'      => 'columns',
        'Intended-For' => 'intended_for',
        'Written-By'   => 'written_by',
        'Line-Count'   => 'line_count',
        'Last-Updated' => 'last_updated',
    );

    my @lines = split "\n", $content;
    my ( %args, @packages );

    while ( my $line = shift @lines ) {
        last if $line =~ /^\s*$/;
        next unless my ( $key, $value ) = $line =~ /^([^:]+):\s*(.*)/;
        $args{$map{$key}} = $value;
    }

    foreach my $line ( @lines ) {
        my ( $name, $version, $distribution ) = split ' ', $line;
        my $package = {
            name         => $name,
            version      => $version,
            distribution => $distribution,
        };
        push @packages, $package;
    }

    $args{packages} = \@packages if @packages;

    return %args;
}

sub default_location { 'modules/02packages.details.txt.gz' }

__PACKAGE__->meta->make_immutable;




=pod

=head1 NAME

CPAN::Index::API::File::PackagesDetails - Write 02packages.details

=head1 VERSION

version 0.004

=head1 SYNOPSIS

  my $pckdetails = CPAN::Index::File::PackagesDetails->parse_from_repo_uri(
    'http://cpan.perl.org'
  );

  foreach my $package ($pckdetails->packages) {
    ... # do something
  }

=head1 DESCRIPTION

This is a class to read and write 03modlist.data

=head1 METHODS

=head2 packages

List of hashrefs representing packages indexed in the file. Each hashref
has the following structure:

=over

=item name

Package name, e.g. C<Foo::Bar>.

=item version

Package version, e.g. C<0.001>.

=item distribuiton

Distribution the package belongs to, e.g. C<Foo-Bar-0.001>.

=back

=head2 package_count

Number of packages indexed in the file.

=head2 filename

Name of this file - defaults to C<02packages.details.txt.gz>;

=head2 description

Short description of the file.

=head2 written_by

Name and version of software that wrote the file.

=head2 intended_for

Target consumers of the file.

=head2 last_updated

Date and time when the file was last updated.

=head2 uri

Absolute URI pointing to the file location.

=head2 parse

Parses the file and reurns its representation as a data structure.

=head2 default_location

Default file location - C<modules/02packages.details.txt.gz>.

=head1 METHODS FROM ROLES

=over

=item <CPAN::Index::API::Role::Reader/read_from_string>

=item <CPAN::Index::API::Role::Reader/read_from_file>

=item <CPAN::Index::API::Role::Reader/read_from_tarball>

=item <CPAN::Index::API::Role::Reader/read_from_repo_path>

=item <CPAN::Index::API::Role::Reader/read_from_repo_uri>

=item L<CPAN::Index::API::Role::Writer/repo_path>

=item L<CPAN::Index::API::Role::Writer/template>

=item L<CPAN::Index::API::File::Role::Writer/content>

=item L<CPAN::Index::API::File::Role::Writer/ write_to_file>

=item L<CPAN::Index::API::File::Role::Writer/write_to_tarball>

=back

=head1 AUTHOR

Peter Shangov <pshangov@yahoo.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2012 by Venda, Inc..

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut


__DATA__
File:         [% $self->filename      %]
URL:          [% $self->uri           %]
Description:  [% $self->description   %]
Columns:      [% $self->columns       %]
Intended-For: [% $self->intended_for  %]
Written-By:   [% $self->written_by    %]
Line-Count:   [% $self->package_count %]
Last-Updated: [% $self->last_updated  %]
[%
    if ($self->package_count)
    {
        $OUT .= "\n";
        foreach my $package ($self->sorted_packages) {
            $OUT .= sprintf "%-34s %5s  %s\n",
                $package->{name},
                defined $package->{version} ? $package->{version} : 'undef',
                $package->{distribution};
        }
    }
    else
    {
        $OUT .= ''; # keeps Text::Template happy
    }
%]
