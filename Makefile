FILES_DIR := files
C9SDK_DIR := $(FILES_DIR)/var/c9sdk
CONFIGS_DIR := $(C9SDK_DIR)/configs/ide
OFFLINE_DIR := /tmp/ide
PLUGINS_DIR := $(C9SDK_DIR)/plugins
VERSION_FILE := $(FILES_DIR)/etc/version50

PLUGINS := audioplayer browser cat debug gist hex info presentation simple statuspage theme

NAME := ide50
VERSION := 158

define getplugin
	@echo "\nFetching $(1)..."
	@plugin_dir="$(PLUGINS_DIR)/c9.ide.cs50.$(1)"; \
	mkdir -p "$$plugin_dir"; \
	git clone --depth=1 "https://github.com/cs50/harvard.cs50.$(1).git" "$$plugin_dir"; \
	rm -rf "$$plugin_dir/README.md" "$$plugin_dir/.git"*

endef

.PHONY: bash
bash:
	docker run -i --rm -t -v "$(PWD):/root" cs50/cli

.PHONY: deb
deb: clean Makefile
	@echo "\nDownloading latest CS50 plugins..."
	$(foreach plugin,$(PLUGINS),$(call getplugin,$(plugin)))

	@echo "\nFetching latest offline configs..."
	mkdir -p "$(CONFIGS_DIR)"
	git clone --depth=1 https://github.com/cs50/ide.git "$(OFFLINE_DIR)"
	@cp "$(OFFLINE_DIR)"/files/workspace-cs50.js "$(CONFIGS_DIR)"

clean:
	@echo "Cleaning up..."
	rm -rf *.deb "$(C9SDK_DIR)" "$(OFFLINE_DIR)" "$(VERSION_FILE)"
