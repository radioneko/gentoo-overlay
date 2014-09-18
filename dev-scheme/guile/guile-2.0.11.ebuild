# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
inherit eutils flag-o-matic elisp-common

DESCRIPTION="GNU Ubiquitous Intelligent Language for Extensions"
HOMEPAGE="http://www.gnu.org/software/guile/"
SRC_URI="mirror://gnu/guile/${P}.tar.gz"

LICENSE="LGPL-3"
KEYWORDS="~amd64 ~x86"
IUSE="networking +regex +deprecated emacs nls debug-malloc debug static-libs +threads"

DEPEND="dev-libs/gmp
	>=sys-devel/libtool-1.5.6
	sys-devel/gettext
	virtual/pkgconfig
	dev-libs/libunistring
	>=dev-libs/boehm-gc-7.0[threads?]
	virtual/libffi
	emacs? ( virtual/emacs )"
RDEPEND="${DEPEND}"

SLOT="12"
MAJOR="2.0"

src_configure() {
	# see bug #178499
	filter-flags -ftree-vectorize

	#will fail for me if posix is disabled or without modules -- hkBst
	econf \
		--disable-error-on-warning \
		--disable-rpath \
		--enable-posix \
		--with-modules \
		$(use_enable networking) \
		$(use_enable regex) \
		$(use_enable deprecated) \
		$(use_enable nls) \
		$(use_enable debug-malloc) \
		$(use_enable debug guile-debug) \
		$(use_enable static-libs static) \
		$(use_with threads)
}

src_compile()  {
	emake

	# Above we have disabled the build system's Emacs support;
	# for USE=emacs we compile (and install) the files manually
	# if use emacs; then
	# 	cd emacs
	# 	make
	# 	elisp-compile *.el || die
	# fi
}

src_install() {
	emake DESTDIR="${D}" install

	dodoc AUTHORS ChangeLog GUILE-VERSION HACKING NEWS README THANKS

	# texmacs needs this, closing bug #23493
	dodir /etc/env.d
	echo "GUILE_LOAD_PATH=\"${EPREFIX}/usr/share/guile/${MAJOR}\"" > "${ED}"/etc/env.d/50guile

	# necessary for registering slib, see bug 206896
	keepdir /usr/share/guile/site

	# if use emacs; then
	# 	elisp-install ${PN} emacs/*.{el,elc} || die
	# 	elisp-site-file-install "${FILESDIR}/50${PN}-gentoo.el" || die
	# fi

	find "${D}" -name '*.la' -delete
}

pkg_postinst() {
	[[ "${EROOT}" == "/" ]] && pkg_config
	use emacs && elisp-site-regen
}

pkg_postrm() {
	use emacs && elisp-site-regen
}

pkg_config() {
	if has_version dev-scheme/slib; then
		einfo "Registering slib with guile"
		install_slib_for_guile
	fi
}

_pkg_prerm() {
	rm -f "${EROOT}"/usr/share/guile/site/slibcat
}
