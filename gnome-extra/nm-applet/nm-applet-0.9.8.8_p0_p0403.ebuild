# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-extra/nm-applet/nm-applet-0.9.8.4.ebuild,v 1.2 2013/11/20 13:15:49 leio Exp $

EAPI=5
GCONF_DEBUG="no"
GNOME2_LA_PUNT="yes"
GNOME_ORG_MODULE="network-manager-applet"

inherit autotools base eutils gnome2 ubuntu-versionator

MY_P="${GNOME_ORG_MODULE}_${PV}"
S="${WORKDIR}/${GNOME_ORG_MODULE}-${PV}"

UURL="mirror://ubuntu/pool/main/n/${GNOME_ORG_MODULE}"
URELEASE="trusty-updates"

DESCRIPTION="GNOME applet for NetworkManager"
HOMEPAGE="http://projects.gnome.org/NetworkManager/"
SRC_URI="${UURL}/${MY_P}.orig.tar.xz
        ${UURL}/${MY_P}-${UVER}.debian.tar.xz"

LICENSE="GPL-2+"
SLOT="0"
IUSE="bluetooth gconf +introspection modemmanager systemd"
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc ~x86"
RESTRICT="mirror"

RDEPEND="
	app-crypt/libsecret
	>=dev-libs/glib-2.26:2
	>=dev-libs/dbus-glib-0.88
	dev-libs/libappindicator:=
	>=sys-apps/dbus-1.6.12[systemd?]
	>=sys-auth/polkit-0.96-r1
	>=x11-libs/gtk+-3:3[introspection?]
	>=x11-libs/libnotify-0.7.0

	app-text/iso-codes
	>=net-misc/networkmanager-0.9.8[introspection?]
	net-misc/mobile-broadband-provider-info

	bluetooth? ( >=net-wireless/gnome-bluetooth-2.27.6 )
	gconf? (
		>=gnome-base/gconf-2.20:2
		gnome-base/libgnome-keyring )
	introspection? ( >=dev-libs/gobject-introspection-0.9.6 )
	modemmanager? ( >=net-misc/modemmanager-0.7.990 )
	virtual/freedesktop-icon-theme
	virtual/libgudev:=
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	>=dev-util/intltool-0.40
"

src_prepare() {
        # Ubuntu patchset #
        for patch in $(cat "${WORKDIR}/debian/patches/series" | grep -v '#'); do
                PATCHES+=( "${WORKDIR}/debian/patches/${patch}" )
        done
        base_src_prepare

	sed -e "s:-Werror::g" \
                -i "configure" || die

	eautoreconf

	gnome2_src_prepare
}

src_configure() {
	gnome2_src_configure \
		--enable-indicator \
		--with-gtkver=3 \
		--disable-more-warnings \
		--disable-static \
		--localstatedir=/var \
		$(use_with bluetooth) \
		$(use_enable gconf migration) \
		$(use_enable introspection) \
		$(use_with modemmanager modem-manager-1)
}

src_install() {
        gnome2_src_install

        insinto /usr/share/icons/hicolor/22x22/apps
        doins "${WORKDIR}"/debian/icons/22/*.png
        dosym nm-signal-00.png \
                /usr/share/icons/hicolor/22x22/apps/gsm-3g-none.png
        dosym nm-signal-00-secure.png \
                /usr/share/icons/hicolor/22x22/apps/gsm-3g-none-secure.png
        dosym nm-signal-25.png \
                /usr/share/icons/hicolor/22x22/apps/gsm-3g-low.png
        dosym nm-signal-25-secure.png \
                /usr/share/icons/hicolor/22x22/apps/gsm-3g-low-secure.png
        dosym nm-signal-50.png \
                /usr/share/icons/hicolor/22x22/apps/gsm-3g-medium.png
        dosym nm-signal-50-secure.png \
                /usr/share/icons/hicolor/22x22/apps/gsm-3g-medium-secure.png
        dosym nm-signal-75.png \
                /usr/share/icons/hicolor/22x22/apps/gsm-3g-high.png
        dosym nm-signal-75-secure.png \
                /usr/share/icons/hicolor/22x22/apps/gsm-3g-high-secure.png
        dosym nm-signal-100.png \
                /usr/share/icons/hicolor/22x22/apps/gsm-3g-full.png
        dosym nm-signal-100-secure.png \
                /usr/share/icons/hicolor/22x22/apps/gsm-3g-full-secure.png
}

pkg_preinst() {
	gnome2_schemas_savelist
}

pkg_postinst() {
	gnome2_schemas_update
}

pkg_postrm() {
	gnome2_schemas_update
}
