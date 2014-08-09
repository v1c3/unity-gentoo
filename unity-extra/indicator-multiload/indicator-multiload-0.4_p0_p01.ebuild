# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
GNOME2_LA_PUNT="yes"
GCONF_DEBUG="yes"

inherit gnome2 ubuntu-versionator

UURL="mirror://ubuntu/pool/universe/i/${PN}"
URELEASE="utopic"

DESCRIPTION="Graphical system load indicator for CPU, ram, etc. used by the Unity desktop"
HOMEPAGE="https://launchpad.net/indicator-multiload"
SRC_URI="${UURL}/${MY_P}.orig.tar.gz"

LICENSE="GPL-3"
SLOT="0"
#KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

RDEPEND="dev-libs/libappindicator:=
	gnome-extra/gnome-system-monitor"

DEPEND="${RDEPEND}
	>=dev-libs/glib-2.28.0
	dev-libs/libdbusmenu
	dev-libs/libindicate[gtk,introspection]
	gnome-base/dconf
	gnome-base/libgtop
	x11-libs/cairo
	x11-libs/gtk+:3"
