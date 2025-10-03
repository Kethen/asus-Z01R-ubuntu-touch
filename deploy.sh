#!/bin/bash
set -xe

deploy () {
	if [ -e ota ]
	then
		rm -r ota
	fi
	./build/prepare-fake-ota.sh out/device_Z01R.tar.xz build_dir/ota
	./build/system-image-from-ota.sh build_dir/ota/ubuntu_command out
	rm deviceinfo
}

deploy
