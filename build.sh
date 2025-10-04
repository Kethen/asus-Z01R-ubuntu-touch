#!/bin/bash
set -xe

export PATH="$(realpath bin):$PATH"

if false
then
	cat vendor_prebuilt/* > vendor_gz.img
	mkdir vendor_mnt
	mount vendor_gz.img vendor_mnt
	cd vendor_mnt
	mksquashfs . ../overlay/system/vendor.img -comp xz
	ls -lsh ../overlay/system/vendor.img
	cd ..
	umount vendor_mnt
	rm vendor_gz.img
fi

[ -d build ] || git clone https://gitlab.com/ubports/community-ports/halium-generic-adaptation-build-tools -b halium-11 build
./build/build.sh "$@"

if false
then
	rm overlay/system/vendor.img
fi
