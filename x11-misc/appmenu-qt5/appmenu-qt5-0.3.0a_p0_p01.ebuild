# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit qt5-build ubuntu-versionator

URELEASE="utopic"
UURL="mirror://ubuntu/pool/main/a/${PN}"
UVER_PREFIX="+14.10.20140528"

DESCRIPTION="Application menu module for Qt"
HOMEPAGE="https://launchpad.net/appmenu-qt"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}.orig.tar.gz"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
#KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

DEPEND="dev-qt/qtcore:5
	dev-qt/qtdbus:5
	dev-qt/qtgui:5
	dev-qt/qtwidgets:5
	dev-libs/libdbusmenu-qt"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}-${PV}${UVER_PREFIX}"
DOCS=( NEWS README )

src_install() {
	qt5-build_src_install

	insinto /etc/profile.d
	doins data/appmenu-qt5.sh
}
