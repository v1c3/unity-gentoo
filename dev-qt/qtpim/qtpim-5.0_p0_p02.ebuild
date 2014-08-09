# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit base qt5-build ubuntu-versionator

UURL="mirror://ubuntu/pool/main/q/${PN}-opensource-src"
URELEASE="trusty"
UVER_PREFIX="~git20140203~e0c5eebe"

DESCRIPTION="Qt PIM module, Organizer library"
SRC_URI="${UURL}/${PN}-opensource-src_${PV}${UVER_PREFIX}.orig.tar.gz
	${UURL}/${PN}-opensource-src_${PV}${UVER_PREFIX}-${UVER}.debian.tar.gz"

KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

DEPEND=">=dev-qt/qtcore-${PV}:5[debug=]
	>=dev-qt/qtdeclarative-${PV}:5[debug=]
	>=dev-qt/qtjsbackend-${PV}:5[debug=]
	>=dev-qt/qtxmlpatterns-${PV}:5[debug=]"

S="${WORKDIR}"

src_prepare() {
	# Ubuntu patchset #
	for patch in $(cat "${WORKDIR}/debian/patches/series" | grep -v \# ); do
		PATCHES+=( "${WORKDIR}/debian/patches/${patch}" )
	done
	qt5-build_src_prepare
	perl -w /usr/$(get_libdir)/qt5/bin/syncqt.pl -version 5.0.0
}
