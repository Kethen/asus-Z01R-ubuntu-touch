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

if true
then
	cat vendor_los/vendor_* > vendor_los.img
	mkdir vendor_los_mnt
	mount vendor_los.img vendor_los_mnt
	cp -a vendor_los_mnt vendor_patched
	set +x
	for f in vendor_patched/lib64/*.so vendor_patched/lib64/hw/*.so vendor_patched/lib/*.so vendor_patched/lib/hw/*.so vendor_patched/bin/* vendor_patched/bin/hw/*
	do
		if [ -n "$(readelf -d $f | grep NEEDED | grep libprotobuf-cpp-lite.so)" ]
		then
			echo patching $f
			patchelf --replace-needed libprotobuf-cpp-lite.so libprotobuf-cpp-lite_v28.so $f
		fi

		if [ -n "$(readelf -d $f | grep NEEDED | grep libprotobuf-cpp-full.so)" ]
		then
			echo patching $f
			patchelf --replace-needed libprotobuf-cpp-full.so libprotobuf-cpp-full_v28.so $f
		fi
	done
	set -x

	mv vendor_patched/lib64/libprotobuf-cpp-lite.so vendor_patched/lib64/libprotobuf-cpp-lite_v28.so
	mv vendor_patched/lib64/libprotobuf-cpp-full.so vendor_patched/lib64/libprotobuf-cpp-full_v28.so
	mv vendor_patched/lib/libprotobuf-cpp-lite.so vendor_patched/lib/libprotobuf-cpp-lite_v28.so
	mv vendor_patched/lib/libprotobuf-cpp-full.so vendor_patched/lib/libprotobuf-cpp-full_v28.so

	rm vendor_los.img

	cd vendor_patched
	rm -f ../out/vendor.img
	mksquashfs . ../out/vendor.img -comp xz
	cd ..
fi

[ -d build ] || git clone https://gitlab.com/ubports/community-ports/halium-generic-adaptation-build-tools -b halium-11 build
./build/build.sh "$@"

if false
then
	rm overlay/system/vendor.img
fi
