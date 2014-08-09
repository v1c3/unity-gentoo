# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
GNOME2_LA_PUNT="yes"
GCONF_DEBUG="yes"

inherit autotools eutils gnome2 systemd vala ubuntu-versionator base

DESCRIPTION="D-Bus interfaces for querying and manipulating user account information"
HOMEPAGE="http://www.fedoraproject.org/wiki/Features/UserAccountDialog"

UURL="mirror://ubuntu/pool/main/a/${PN}"
URELEASE="trusty-updates"

SRC_URI="${UURL}/${MY_P}.orig.tar.xz
	${UURL}/${MY_P}${UVER_PREFIX}-${UVER}.debian.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="doc +introspection systemd vala"
REQUIRED_USE="vala? ( introspection )"
RESTRICT="mirror"

# Want glib-2.30 for gdbus
RDEPEND=">=dev-libs/glib-2.37.3:2
	sys-auth/polkit
	introspection? ( >=dev-libs/gobject-introspection-0.9.12 )
	systemd? ( >=sys-apps/systemd-186 )
	!systemd? ( sys-auth/consolekit )"
DEPEND="${RDEPEND}
	app-crypt/gcr
	dev-libs/libxslt
	dev-util/gdbus-codegen
	>=dev-util/gtk-doc-am-1.15
	>=dev-util/gtk-doc-1.18
	>=dev-util/intltool-0.40
	sys-devel/gettext
	virtual/pkgconfig
	doc? (
		app-text/docbook-xml-dtd:4.1.2
		app-text/xmlto )
	vala? ( $(vala_depend) )"

pkg_setup() {
	ubuntu-versionator_pkg_setup
	if [[ ( $(gcc-major-version) -eq 4 && $(gcc-minor-version) -lt 7 && $(gcc-micro-version) -lt 3 ) ]]; then
		die "${P} requires an active >=gcc-4.7.3, please consult the output of 'gcc-config -l'"
	fi
}

src_prepare() {
	# Disable selected patches #
	sed -i '/0002-create-and-manage-groups-like-on-a-ubuntu-system.patch/d' "${WORKDIR}/debian/patches/series" || die
	sed -i '/0002-create-and-manage-groups-like-on-a-debian-system.patch/d' "${WORKDIR}/debian/patches/series" || die
	sed -i '/0006-adduser_instead_of_useradd.patch/d' "${WORKDIR}/debian/patches/series" || die
	sed -i '/0009-language-tools.patch/d' "${WORKDIR}/debian/patches/series" || die
	sed -i '/0010-set-language.patch/d' "${WORKDIR}/debian/patches/series" || die
	sed -i '/0013-add-has-message-support.patch/d' "${WORKDIR}/debian/patches/series" || die
	sed -i '/1001-buildsystem.patch/d' "${WORKDIR}/debian/patches/series" || die
	sed -i '/2001-filtering_out_users.patch/d' "${WORKDIR}/debian/patches/series" || die
	sed -i '/2002-disable_systemd.patch/d' "${WORKDIR}/debian/patches/series" || die

	for patch in $(cat "${WORKDIR}/debian/patches/series" | grep -v '#'); do
		PATCHES+=( "${WORKDIR}/debian/patches/${patch}" )
	done
	base_src_prepare

	eautoreconf

	use vala && vala_src_prepare
	gnome2_src_prepare
}

src_configure() {
	DOCS="AUTHORS NEWS README TODO"
	G2CONF="${G2CONF}
		--disable-static
		--disable-more-warnings
		--localstatedir="${EPREFIX}"/var
		--docdir="${EPREFIX}"/usr/share/doc/${PF}
		$(use_enable doc docbook-docs)
		$(use_enable introspection)
		$(use_enable vala)
		$(use_enable systemd)
		$(systemd_with_unitdir)"
	gnome2_src_configure
}
