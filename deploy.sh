#!/bin/bash
set -xe

deploy () {
	if [ -e ota ]
	then
		rm -r ota
	fi
	./build/prepare-fake-ota.sh out/device.tar.xz ota
	./build/system-image-from-ota.sh ota/ubuntu_command out
	rm deviceinfo
}

deploy
