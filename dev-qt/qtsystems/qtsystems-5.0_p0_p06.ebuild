# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit base qt5-build ubuntu-versionator

UURL="mirror://ubuntu/pool/universe/q/${PN}-opensource-src"
URELEASE="utopic"
UVER_PREFIX="~git20130712"

SRC_URI="${UURL}/${PN}-opensource-src_${PV}${UVER_PREFIX}.orig.tar.gz
	${UURL}/${PN}-opensource-src_${PV}${UVER_PREFIX}-${UVER}.debian.tar.xz"

DESCRIPTION="The Qt toolkit is a comprehensive C++ application development framework"

#KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

RDEPEND="
	dev-qt/qtcore:5
	dev-qt/qtxmlpatterns:5
	dev-qt/qtdeclarative:5
	dev-qt/qtjsbackend:5
"
DEPEND="${RDEPEND}
	gnome-base/gconf
	net-wireless/bluez
	virtual/udev
	x11-libs/libX11
"

S="${WORKDIR}"
QT5_BUILD_DIR="${S}"

src_prepare() {
        # Ubuntu patchset #
        for patch in $(cat "${WORKDIR}/debian/patches/series" | grep -v \# ); do
                PATCHES+=( "${WORKDIR}/debian/patches/${patch}" )
        done

        qt5-build_src_prepare

	perl -w /usr/$(get_libdir)/qt5/bin/syncqt.pl -version 5.2.0
}
