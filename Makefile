SRC_DIR		?= freebsd-src
BRANCH		?= releng/15.1
SRC_URL		?= https://git.FreeBSD.org/src.git
KERNCONF	?= GENERIC
PATCHFILE	 = patches/acpi_video.patch
PATCHMARKER	 ?= bclh
VIDSRC		 = $(SRC_DIR)/sys/dev/acpica/acpi_video.c
MODDIR		 = $(SRC_DIR)/sys/modules/acpi/acpi_video
KBUILDDIR	 = $(SRC_DIR)/sys/compile/$(KERNCONF)

.PHONY: all clone patch build install clean distclean

all: build

clone:
	[ -d $(SRC_DIR) ] || git clone --depth 1 -b $(BRANCH) $(SRC_URL) $(SRC_DIR)

patch: clone
	@if grep -q $(PATCHMARKER) $(VIDSRC); then \
		echo "$(PATCHFILE) already applied; skipping"; \
	else \
		patch -d $(SRC_DIR) -p1 < $(PATCHFILE); \
	fi

build: patch
	mkdir -p $(KBUILDDIR)
	cd $(SRC_DIR)/sys/amd64/conf && config -d ../../compile/$(KERNCONF) $(KERNCONF)
	rm -f $(MODDIR)/opt_acpi.h $(MODDIR)/opt_evdev.h
	$(MAKE) -C $(MODDIR) KERNBUILDDIR="$$PWD/$(KBUILDDIR)"
	cp $(MODDIR)/acpi_video.ko .

install: build
	cp acpi_video.ko /boot/modules/

clean:
	rm -f acpi_video.ko
	@if [ -d $(MODDIR) ] && [ -d $(KBUILDDIR) ]; then \
		$(MAKE) -C $(MODDIR) KERNBUILDDIR="$$PWD/$(KBUILDDIR)" clean; \
	fi
	rm -rf $(KBUILDDIR)

distclean: clean
	rm -rf $(SRC_DIR)
