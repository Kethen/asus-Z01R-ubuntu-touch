cat vendor_los/vendor_* > vendor_los.img
mkdir vendor_los_mnt
mount vendor_los.img vendor_los_mnt
cp -a vendor_los_mnt vendor_patched
umount vendor_los_mnt
rm vendor_los.img

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

cd vendor_patched
rm -f ../out/vendor.img
mksquashfs . ../out/vendor.img -comp xz
cd ..
