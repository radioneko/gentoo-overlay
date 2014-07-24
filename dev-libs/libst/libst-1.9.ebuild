# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit eutils multilib

DESCRIPTION="State threads library"
HOMEPAGE="http://state-threads.sourceforge.net/"
SRC_URI="mirror://sourceforge/state-threads/state-threads/st-${PV}.tar.gz"

LICENSE="MPL"
SLOT="0"
KEYWORDS="x86 amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

MY_PN="st"
S="${WORKDIR}/st-${PV}"

src_configure() {
	# do nothing
	true
}

src_compile() {
	make linux-optimized
}

src_install() {
	insinto /usr/include
	doins obj/st.h

	insinto /usr/$(get_libdir)/pkgconfig
	sed -i -e "s*@prefix@*/usr*g" st.pc
	doins st.pc

	dolib.so obj/libst.so*
#	mkdir -m 0755 -p "${R}/lib/pkgconfig"
#	mkdir -m 0755 -p ${R}/include
#	mkdir -m 0755 -p ${R}/share/doc/libst-devel
#	cp -a obj/libst.* ${R}/lib
#	cp -a obj/st.h    ${R}/include
#	>${RPM_BUILD_ROOT}/%{prefix}/lib/pkgconfig/st.pc
#	cp -a docs/*      ${RPM_BUILD_ROOT}/%{prefix}/share/doc/libst-devel/
#	cp -a examples    ${RPM_BUILD_ROOT}/%{prefix}/share/doc/libst-devel/
	dodoc README docs/*
}
