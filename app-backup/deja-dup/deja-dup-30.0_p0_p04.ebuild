# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
VALA_MIN_API_VERSION="0.22"
VALA_MAX_API_VERSION="0.22"
inherit cmake-utils ubuntu-versionator vala

UURL="mirror://ubuntu/pool/main/d/${PN}"
URELEASE="trusty"

DESCRIPTION="Simple backup tool using duplicity back-end"
HOMEPAGE="https://launchpad.net/deja-dup/"
SRC_URI="${UURL}/${MY_P}.orig.tar.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+nautilus"
RESTRICT="mirror test"

COMMON_DEPEND="
	app-crypt/libsecret[vala]
	dev-libs/libdbusmenu:=
	dev-libs/libunity:=
	dev-libs/glib:2
	dev-libs/libpeas
	unity-base/unity-control-center
	x11-libs/gtk+:3
	x11-libs/libnotify

	app-backup/duplicity
	dev-libs/dbus-glib

	nautilus? ( gnome-base/nautilus )"
RDEPEND="${COMMON_DEPEND}
	gnome-base/gvfs[fuse]"
DEPEND="${COMMON_DEPEND}
	app-text/yelp-tools
	dev-perl/Locale-gettext
	virtual/pkgconfig
	dev-util/intltool
	sys-devel/gettext
	$(vala_depend)"

src_prepare() {
	vala_src_prepare
	export VALA_API_GEN="$VAPIGEN"
}

src_configure() {
        local mycmakeargs="${mycmakeargs}
                -DVALA_COMPILER=$VALAC
                -DVAPI_GEN=$VAPIGEN"
        cmake-utils_src_configure
}

