# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="fwknop stands for the \"FireWall KNock OPerator\", and implements an authorization scheme called Single Packet Authorization (SPA)."
HOMEPAGE="http://www.cipherdyne.org/fwknop/"
PACK_NAME="fwknop-2.0.0rc2"
SRC_URI="http://www.cipherdyne.org/fwknop/download/${PACK_NAME}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"
IUSE="server"

DEPEND=""
RDEPEND=""

src_unpack() {
	if [ "${A}" != "" ]; then
    	unpack ${A};
	fi
	mv ${PACK_NAME} ${P}
}

src_compile() {
	econf --without-gpgme $(use_enable server)
	emake || die
}

src_install() {
	emake DESTDIR="${D}" install || die
}
