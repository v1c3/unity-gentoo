# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit autotools eutils ubuntu-versionator

UURL="mirror://ubuntu/pool/universe/i/${PN}"
URELEASE="trusty"
UVER_PREFIX="+14.04.20140403"

DESCRIPTION="Gnome panel indicator for the Unity desktop"
HOMEPAGE="https://launchpad.net/indicator-applet"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}.orig.tar.gz"

LICENSE="LGPL-2.1 LGPL-3 GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

DEPEND="dev-libs/libindicator:3
	x11-libs/gtk+:3
	>=gnome-base/gnome-panel-3.6"

S="${WORKDIR}/${PN}-${PV}${UVER_PREFIX}"

src_prepare() {
	# some API is declared as deprecated in gtk+ 3.10
	epatch "${FILESDIR}/remove_GTK_DISABLE_DEPRECATED.patch"

	# "Only <glib.h> can be included directly." #
	sed -e "s:glib/gtypes.h:glib.h:g" \
		-i src/tomboykeybinder.h
	eautoreconf
}
