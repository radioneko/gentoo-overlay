# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

inherit eutils autotools

DESCRIPTION="CMPH - C Minimal Perfect Hashing Library"
HOMEPAGE="http://cmph.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE="debug static-libs"

DEPEND=""
RDEPEND=""

src_prepare() {
	default
	epatch "${FILESDIR}/cflags.patch"
	eautoreconf
	elibtoolize
}

src_configure() {
	ECONF_SOURCE="${S}" \
	econf \
		--disable-cxxmph \
		$(use_enable static-libs static)
}
