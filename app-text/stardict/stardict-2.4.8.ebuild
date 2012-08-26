# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

# NOTE: Even though the *.dict.dz are the same as dictd/freedict's files,
#       their indexes seem to be in a different format. So we'll keep them
#       seperate for now.

EAPI=4

GNOME2_LA_PUNT=yes
GCONF_DEBUG=no

inherit autotools eutils gnome2 

IUSE="gnome"
DESCRIPTION="A GNOME2 international dictionary supporting fuzzy and glob style matching"
HOMEPAGE="http://code.google.com/p/stardict-3/"
SRC_URI="http://${PN}-3.googlecode.com/files/${P}.tar.bz2"

RESTRICT="test"
LICENSE="GPL-2"
SLOT="0"
# when adding keywords, remember to add to stardict.eclass
KEYWORDS="amd64 ppc ~ppc64 ~sparc x86"

RDEPEND="gnome? ( >=gnome-base/libbonobo-2.2.0
		>=gnome-base/libgnome-2.2.0
		>=gnome-base/libgnomeui-2.2.0
		>=gnome-base/gconf-2
		>=gnome-base/orbit-2.6
		app-text/scrollkeeper )
	>=sys-libs/zlib-1.1.4
	>=dev-libs/popt-1.7
	>=x11-libs/gtk+-2.6"

DEPEND="${RDEPEND}
	>=dev-util/intltool-0.22
	dev-util/pkgconfig"

RESTRICT="test"

pkg_setup() {
	G2CONF="$(use_enable gnome gnome-support)"
}

src_prepare() {
	epatch \
		"${FILESDIR}"/${P}-ClipboardReceivedCallback.patch \
		"${FILESDIR}"/${P}-floatwin-disappear.patch \
		"${FILESDIR}"/${P}-missing-headers.patch \
		"${FILESDIR}"/${P}-ldadd.patch
	
	eautoreconf
	gnome2_src_prepare
}

pkg_postinst() {
	elog "You will now need to install stardict dictionary files. If"
	elog "you have not, execute the below to get a list of dictionaries:"
	elog
	elog "  emerge -s stardict-"
	elog

	gnome2_pkg_postinst
}
