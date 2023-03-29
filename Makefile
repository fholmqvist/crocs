install:
	crystal build --release src/main.cr
	sudo mv main /usr/bin/crocs
	@echo Installed crocs OK.
