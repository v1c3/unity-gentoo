# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
inherit base eutils pam readme.gentoo ubuntu-versionator user autotools systemd

UURL="mirror://ubuntu/pool/main/l/${PN}"
URELEASE="saucy"

DESCRIPTION="A lightweight display manager"

HOMEPAGE="https://launchpad.net/lightdm"
SRC_URI="${UURL}/${MY_P}.orig.tar.xz
	${UURL}/${MY_P}${UVER_PREFIX}-${UVER}.debian.tar.gz"

LICENSE="GPL-3 LGPL-3"
SLOT="0"
#KEYWORDS="~amd64 ~x86"


IUSE_LIGHTDM_GREETERS="gtk unity kde razor"
for greeters in ${IUSE_LIGHTDM_GREETERS}; do
        IUSE+=" lightdm_greeters_${greeters}"
done

IUSE+=" +introspection qt4 qt5"

RESTRICT="mirror"

COMMON_DEPEND=">=dev-libs/glib-2.32.3:2
	dev-libs/libxml2
	sys-apps/accountsservice
	virtual/pam
	x11-libs/libX11
	>=x11-libs/libxklavier-5
	introspection? ( >=dev-libs/gobject-introspection-1 )
	qt4? (
		dev-qt/qtcore:4
		dev-qt/qtdbus:4
		dev-qt/qtgui:4
		)
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtdbus:5
		dev-qt/qtgui:5
		)"

RDEPEND="${COMMON_DEPEND}
	>=sys-auth/pambase-20101024-r2
	x11-apps/xrandr
	app-admin/eselect-lightdm"

DEPEND="${COMMON_DEPEND}
	dev-util/gtk-doc-am
	dev-util/intltool
	gnome-base/gnome-common
	sys-devel/gettext
	virtual/pkgconfig
	app-text/yelp-tools"

PDEPEND="lightdm_greeters_gtk? ( x11-misc/lightdm-gtk-greeter )
	lightdm_greeters_kde? ( x11-misc/lightdm-kde )
	lightdm_greeters_razor? ( razorqt-base/razorqt-lightdm-greeter )
	lightdm_greeters_unity? ( unity-extra/unity-greeter )"

DOCS=( NEWS )

pkg_pretend() {
	if [[ $(gcc-major-version) -lt 4 ]] || \
		( [[ $(gcc-major-version) -eq 4 && $(gcc-minor-version) -lt 7 ]] ) || \
			( [[ $(gcc-version) == "4.7" && $(gcc-micro-version) -lt 3 ]] ); then
				die "${P} requires an active >=gcc-4.7.3, please consult the output of 'gcc-config -l'"
	fi
}

pkg_setup() {
        if [ -z "${LIGHTDM_GREETERS}" ]; then
		ewarn " "
                ewarn "At least one GREETER should be set in /etc/make.conf"
		ewarn " "
        fi
}

src_prepare() {
	sed -i -e 's:getgroups:lightdm_&:' tests/src/libsystem.c || die #412369
	sed -i -e '/minimum-uid/s:500:1000:' data/users.conf || die

	# remove not needed patches
	sed -i '/01_transition_ubuntu2d_ubuntu_desktop.patch/d' "${WORKDIR}/debian/patches/series" || die
	sed -i '/03_launch_dbus.patch/d' "${WORKDIR}/debian/patches/series" || die
	sed -i '/04_language_handling.patch/d' "${WORKDIR}/debian/patches/series" || die
	sed -i '/05_add_xserver_core_option.patch/d' "${WORKDIR}/debian/patches/series" || die

	# apply remaining patches
	for patch in $(cat "${WORKDIR}/debian/patches/series" | grep -v '#'); do
		PATCHES+=( "${WORKDIR}/debian/patches/${patch}" )
	done

	epatch_user

	base_src_prepare

	if has_version dev-libs/gobject-introspection; then
		eautoreconf
	else
		AT_M4DIR=${WORKDIR} eautoreconf
	fi
}

src_configure() {
	# hack setting moc-5 version as long as 'qtchooser' not available
	MOC5=/usr/$(get_libdir)/qt5/bin/moc \
	econf \
		--localstatedir=/var \
		--disable-static \
		$(use_enable introspection) \
		$(use_enable qt4 liblightdm-qt) \
		$(use_enable qt5 liblightdm-qt5) \
		--with-html-dir="${EPREFIX}"/usr/share/doc/${PF}/html
}

pkg_preinst() {
	enewgroup lightdm || die "problem adding 'lightdm' group"
	enewgroup video
	enewgroup vboxguest
	enewuser lightdm -1 -1 /var/lib/lightdm "lightdm,video,vboxguest" || die "problem adding 'lightdm' user"
}

src_install() {
	default

	insinto /etc/${PN}
	doins data/keys.conf
	newins data/${PN}.conf ${PN}.conf_example
	doins "${FILESDIR}"/${PN}.conf
	doins "${FILESDIR}"/Xsession
	fperms +x /etc/${PN}/Xsession

	# script for lauching greeter sessions itself
	# fixes problems with additional (2nd) nm-applet and
	# setting icon themes in Unity desktop
	doins "${FILESDIR}"/lightdm-greeter-session
	fperms +x /etc/${PN}/lightdm-greeter-session

	# script makes lightdm multi monitor sessions aware
	# and enable first display as primary output
	# all other monitors are aranged right of it in a row
	#
	# on 'unity-greeter' the login prompt will follow the mouse cursor
	#
	doins "${FILESDIR}"/lightdm-greeter-display-setup
	fperms +x /etc/${PN}/lightdm-greeter-display-setup

	prune_libtool_files --all
	rm -rf "${ED}"/etc/init

	pamd_mimic system-local-login ${PN} auth account session #372229
	dopamd "${FILESDIR}"/${PN}-autologin #390863, #423163

	readme.gentoo_create_doc

	systemd_dounit "${FILESDIR}/${PN}.service"
}
