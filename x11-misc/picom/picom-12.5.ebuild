# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..13} )
inherit meson python-any-r1 virtualx xdg

DESCRIPTION="A lightweight compositor for X11 (previously a compton fork)"
HOMEPAGE="https://github.com/yshui/picom"
SRC_URI="https://github.com/yshui/picom/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MPL-2.0 MIT"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~ppc64 ~riscv x86"
IUSE="dbus +doc +drm opengl pcre test"

REQUIRED_USE="test? ( dbus )" # avoid "DBus support not compiled in!"
RESTRICT="test" # but tests require dbus_next

RDEPEND="dev-libs/libconfig:=
	dev-libs/libev
	dev-libs/uthash
	x11-libs/libX11
	x11-libs/libxcb
	x11-libs/pixman
	x11-libs/xcb-util
	x11-libs/xcb-util-image
	x11-libs/xcb-util-renderutil
	dbus? ( sys-apps/dbus )
	drm? ( x11-libs/libdrm )
	opengl? (
		media-libs/libepoxy
		virtual/opengl
	)
	pcre? ( dev-libs/libpcre2:= )"
DEPEND="${RDEPEND}
	x11-base/xorg-proto"
BDEPEND="virtual/pkgconfig
	doc? ( dev-ruby/asciidoctor )
	test? ( $(python_gen_any_dep 'dev-python/xcffib[${PYTHON_USEDEP}]') )
"

DOCS=( README.md picom.sample.conf )

python_check_deps() {
	python_has_version "dev-python/xcffib[${PYTHON_USEDEP}]"
}

pkg_setup() {
	use test && python-any-r1_pkg_setup
}

src_configure() {
	local emesonargs=(
		$(meson_use dbus)
		$(meson_use doc with_docs)
		$(meson_use opengl)
		$(meson_use pcre regex)
	)

	meson_src_configure
}

src_test() {
	virtx "${S}/tests/run_tests.sh" "${BUILD_DIR}/src/${PN}"
}
