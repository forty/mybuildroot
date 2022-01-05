MAKEFLAGS := --jobs=$(shell nproc)

CUSTOM_DIR := $(PWD)/custom

.PHONY: all
all: raspberrypi

buildroot/.git:
	git submodule update --init

.PHONY: raspberrypi_defconfig
raspberrypi_defconfig: buildroot/.git
	mkdir -p ./build/raspberrypi/
	cd buildroot ; \
		./support/kconfig/merge_config.sh \
			-e $(CUSTOM_DIR)\
			-O $(PWD)/build/raspberrypi/ \
			$(CUSTOM_DIR)/configs/raspberrypi_defconfig \
			$(CUSTOM_DIR)/support/config-fragments/ccache.config

.PHONY: raspberrypi
raspberrypi: raspberrypi_defconfig
	$(MAKE) -C build/raspberrypi/

.PHONY: clean
clean:
	$(MAKE) -C build/raspberrypi/ clean
