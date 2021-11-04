# anothervr Makefile

# Ignore whitespace warnings:
IGNORED_WARNINGS:=611 612 614

# Storing a value requires a single line shell string. Note that 
#  then, else and fi do not take a ;, all other lines do. 
#  the muted echo allows the $shell echoes to be printed.
default: check
	@echo "$(shell \
		export NOERRS="`grep --only-matching "0 errors" check.log`" ; \
		if [ "$$NOERRS" = "0 errors" ]; then \
			echo "Build OK! Pushing to device..." ;\
			make install ;\
		else \
			echo "Build errors detected." ;\
		fi \
	)"
	 
# Perform main linter operation on all local lua files. 
#   '-' tells Make to ignore fails.
#   Print the colored version for our benefit. 	 
check:
	rm -rf check.log 
	-luacheck **/*.lua --no-color --ignore $(IGNORED_WARNINGS) > check.log
	-luacheck **/*.lua --ignore $(IGNORED_WARNINGS)
	@echo Luacheck finished. 
	@echo ---

# Push the app to the device.
install:
	adb push --sync ./app/. /sdcard/Android/data/org.lovr.app/files

# Clean the log and delete all the app files on the device
clean:
	rm -rf check.log 
	adb shell rm -rf /sdcard/Android/data/org.lovr.app
