EAPI=4
PYTHON_DEPEND="3:3.2"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="2.*"

inherit distutils

UVER="0.1-0ubuntu1"
URELEASE="quantal"
MY_P="${P/radios-/radios_}"

DESCRIPTION="Online radio lens used by the Unity desktop"
HOMEPAGE="https://launchpad.net/ubuntu/${URELEASE}/+source/${PN}"
SRC_URI="https://launchpad.net/ubuntu/${URELEASE}/+source/${PN}/${UVER}/+files/${MY_P}.orig.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-lang/python:3.2
	dev-python/argparse
	>=dev-python/python-distutils-extra-2.35
	unity-base/unity"