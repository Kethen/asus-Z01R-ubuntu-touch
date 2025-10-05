### Ubuntu touch port for Z01R (ASUS Zenfone 5Z)

Ubuntu touch port for Z01R, based on the hardwork of the developers of https://wiki.lineageos.org/devices/Z01R/ and https://gitlab.com/ubports/porting/community-ports/android11/xiaomi-poco-x3-pro 

#### TODO:

- investigate video recording crash
	- investigate why hybris camera_service gets a null pointer deref in `android::BpMediaRecorderObserver::recordingStarted()`, will likely have to make disk space and setup halium build
- find a good way to include and ship vendor partition
- get lpm mode working
- notch configuration
- test gps
- test fingerprint sensor (my phone does not have a fingerprint sensor and that brings down the hal, can't test)
- test calling & SMS (I only have callable esims)
- test bluetooth
- cleanup gitlab ci
- investigate poweroff reboot
