SRC_DIR ?= freebsd-src
BRANCH  ?= releng/15.1

.PHONY: all clone patch build install clean distclean

all: build

clone:
	git clone --depth 1 -b $(BRANCH) https://git.FreeBSD.org/src.git $(SRC_DIR)

patch: clone
	patch -d $(SRC_DIR) -p1 < patches/acpi_video.patch

build: patch
	make -C $(SRC_DIR)/sys/modules/acpi/acpi_video
	cp $(SRC_DIR)/sys/modules/acpi/acpi_video/acpi_video.ko .

install: build
	cp acpi_video.ko /boot/modules/

clean:
	rm -f acpi_video.ko

distclean: clean
	rm -rf $(SRC_DIR)
