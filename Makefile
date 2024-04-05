# what
PROG = bc-hcc-cryosparc
SPEC = ondemand-bc_hcc_cryosparc.spec

VERSION = $(shell ${GIT} describe --tags | ${SED} 's/-/_/g')

# needed programs to build or install
GIT = /usr/bin/git
SED = /bin/sed
TAR = /bin/tar
GZIP = /bin/gzip
RPMBUILD = /usr/bin/rpmbuild
MOCK = /usr/bin/mock

# mock variables
RESULTDIR ?= artifacts
CACHEDIR ?= .cache/mock
ARCH ?= epel-7-x86_64
CI_PROJECT_DIR ?= /tmp

all: srpm rpm clean

${PROG}-${VERSION}.tar.gz:
	${TAR} --transform "s/^\./${PROG}-${VERSION}/" \
	       --exclude=${PROG}.tar \
               --exclude=${PROG}.tar.gz \
	       --exclude=${RESULTDIR} \
	       --exclude=${CACHEDIR} \
	       --exclude-vcs \
	       -cf ${PROG}.tar .
	${GZIP} -9 -f ${PROG}.tar

tar: ${PROG}-${VERSION}.tar.gz

srpm: tar
	${MOCK} -N -r ${ARCH} --buildsrpm --define='package_version ${VERSION}' --sources=${PROG}.tar.gz \
        --spec=${SPEC} --resultdir=${RESULTDIR}/${ARCH} --plugin-option=root_cache:dir="${CACHEDIR}/%(root)s"

rpm: srpm
	${MOCK} -N -r ${ARCH} --define='package_version ${VERSION}' --resultdir=${RESULTDIR}/${ARCH} \
	--rebuild --plugin-option=root_cache:dir="${CACHEDIR}/%(root)s" ${RESULTDIR}/${ARCH}/*.src.rpm

clean:
	-${RM} ${PROG}.tar.gz
	-${RM} ${RESULTDIR}/${ARCH}/*.rpm
