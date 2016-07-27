# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit autotools eutils

DESCRIPTION="InstallShield CAB file extractor"
HOMEPAGE="https://github.com/twogood/unshield https://sourceforge.net/projects/synce/"
SRC_URI="mirror://gentoo/${P}.tar.xz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~ppc ~x86"
IUSE="libressl static-libs"

RDEPEND="
	!libressl? ( dev-libs/openssl:0= )
	libressl? ( dev-libs/libressl:0= )
	sys-libs/zlib"
DEPEND="${RDEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-bootstrap.patch
	./bootstrap
	sed -i -e 's:AM_CONFIG_HEADER:AC_CONFIG_HEADERS:' configure.ac || die #467548
	AT_M4DIR=m4 eautoreconf
}

src_configure() {
	econf \
		$(use_enable static-libs static) \
		--with-ssl
}

src_install() {
	emake DESTDIR="${D}" install
	dodoc README

	find "${D}" -name '*.la' -exec rm -f {} +
}
