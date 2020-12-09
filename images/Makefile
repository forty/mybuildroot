.PHONY: raspberrypi all raspberrypi_defconfig clean

CUSTOM_DIR := $(PWD)/custom

all: raspberrypi

buildroot/.git:
	git submodule update --init

raspberrypi_defconfig: buildroot/.git
	mkdir -p ./build/raspberrypi/
	cd buildroot ; \
		./support/kconfig/merge_config.sh \
			-e $(CUSTOM_DIR)\
			-O $(PWD)/build/raspberrypi/ \
			$(CUSTOM_DIR)/configs/raspberrypi_defconfig \
			$(CUSTOM_DIR)/support/config-fragments/common/ccache.config

raspberrypi: raspberrypi_defconfig
	$(MAKE) -C build/raspberrypi/ $(CCACHE_OPTIONS)

clean:
	$(MAKE) -C build/raspberrypi/ clean
