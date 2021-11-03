IGNORED_WARNINGS:=611 612 614

default: check
	@echo $(shell \
		export ERRS="`grep --only-matching "0 errors" check.log`" ; \
		if [ "$$ERRS" = "0 errors" ]; then \
			echo "Build OK! Pushing to device..." ;\
			make install; \
		else \
			echo "Build errors detected." ;\
		fi \
	)
	 
check:
	rm -rf check.log 
	-luacheck ./app/*.lua --no-color --ignore $(IGNORED_WARNINGS) > check.log
	-luacheck ./app/*.lua --ignore $(IGNORED_WARNINGS)
	@echo Luacheck finished. 
	@echo ---

install:
	adb push --sync ./app/. /sdcard/Android/data/org.lovr.app/files

clean:
	rm -rf check.log 
	adb shell rm -rf /sdcard/Android/data/org.lovr.app
