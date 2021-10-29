IGNORED_WARNINGS:=611 612 614

default: check
check:
	-luacheck ./app/*.lua --ignore $(IGNORED_WARNINGS) > check.log
	cat check.log

install:
	adb push --sync ./app/. /sdcard/Android/data/org.lovr.app/files

clean:
	adb shell rm -rf /sdcard/Android/data/org.lovr.app
