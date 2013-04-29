use strict;
use warnings;

use Test::More;
if( not -e -d '/usr/portage/' ){
    plan skip_all => 'Test needs a working portage in /usr/portage/'
}

use Gentoo::Overlay;
use Gentoo::Perl::Distmap::FromOverlay;


my $conversion = Gentoo::Perl::Distmap::FromOverlay->new(
    overlay => Gentoo::Overlay->new( path => '/usr/portage' ),
);

local *Gentoo::Perl::Distmap::FromOverlay::_on_enter_category = sub {
    print '/';
};

local *Gentoo::Perl::Distmap::FromOverlay::_on_enter_package = sub {
    print '_';
};
local *Gentoo::Perl::Distmap::FromOverlay::_on_enter_ebuild = sub {
    print '.';
};

my $result = $conversion->distmap;

isnt( $result , undef , 'Got something' );
isa_ok( $result, 'Gentoo::Perl::Distmap' );

use Data::Dump qw(pp);
pp $result->map;

done_testing;

