# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit eutils git-r3 python-single-r1

DESCRIPTION="config generator for youcompleteme"
HOMEPAGE="https://github.com/rdnetto/YCM-Generator"
EGIT_REPO_URI="git://github.com/rdnetto/YCM-Generator.git"
EGIT_BRANCH="stable"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	${PYTHON_DEPS}
"

DEPEND="
	${PYTHON_DEPS}
"

src_install() {
	dodir /usr/libexec/ycm-generator
	insinto /usr/libexec/ycm-generator
	insopts -m 0644
	doins template.py
	insopts -m 0755
	doins config_gen.py
	doins -r fake-toolchain
	dosym ../libexec/ycm-generator/config_gen.py /usr/bin/ycm-gen
}
