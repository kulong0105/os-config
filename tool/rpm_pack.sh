#!/bin/bash

pkg_name="zabbix-web"
BM_ROOT="/home/renyl/testdir/zabbix-web"

mkdir -p /tmp/$pkg_name/{BUILD,RPMS,S{OURCE,PEC,RPM}S}
cat > /tmp/$pkg_name/SPECS/$pkg_name.spec <<-EOF
Name: $pkg_name
Version: 1
License: None
Packager: SkyData
Release: 1
Summary: SkyAXE dependent packages

%description
SkyAXE web-ui rpm package

%install
# create directories where the files will be located
mkdir -p \$RPM_BUILD_ROOT/
# put the files in the relevant directories
cp -a $BM_ROOT/* \$RPM_BUILD_ROOT/

%post
/usr/sbin/update-alternatives --install /usr/share/zabbix/fonts/graphfont.ttf \
zabbix-web-font /usr/share/fonts/dejavu/DejaVuSans.ttf 10

%postun
/usr/sbin/update-alternatives --remove zabbix-web-font \
/usr/share/fonts/dejavu/DejaVuSans.ttf

%files
%defattr(-,root,root)
/*
EOF

cat > /tmp/$pkg_name/.rpmmacros <<-EOF
%_topdir /tmp/$pkg_name
%_rpmfilename %%{NAME}.rpm
EOF

(
    export HOME=/tmp/$pkg_name
    rpmbuild -bb --verbose /tmp/$pkg_name/SPECS/$pkg_name.spec
)

