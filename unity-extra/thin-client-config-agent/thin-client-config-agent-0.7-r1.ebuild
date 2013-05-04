# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

PYTHON_COMPAT=( python{3_1,3_2,3_3} )

inherit ubuntu-versionator distutils-r1

UURL="mirror://ubuntu/pool/main/t/${PN}"
URELEASE="raring"
GNOME2_LA_PUNT="1"
UVER=

DESCRIPTION="Retrieve the list of remote desktop servers for a user."
HOMEPAGE="https://launchpad.net/ubuntu/+source/thin-client-config-agent"
SRC_URI="${UURL}/${PN}_${PV}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

DEPEND="dev-python/pyflakes
	>=dev-python/pycurl-7.19.0-r3
	dev-python/http-parser"

python_install_all() {
	distutils_src_install
	
	exeinto /usr/bin
	doexe ${S}/thin-client-config-agent
}