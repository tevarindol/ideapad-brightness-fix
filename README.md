# ideapad-brightness-fix

[![Build](https://github.com/tevarindol/ideapad-brightness-fix/actions/workflows/build.yml/badge.svg)](https://github.com/tevarindol/ideapad-brightness-fix/actions/workflows/build.yml)
[![Release](https://img.shields.io/github/v/release/tevarindol/ideapad-brightness-fix)](https://github.com/tevarindol/ideapad-brightness-fix/releases)
[![FreeBSD](https://img.shields.io/badge/FreeBSD-15.1-red.svg)](https://www.freebsd.org/)
[![License](https://img.shields.io/badge/license-BSD--2--Clause-blue.svg)](LICENSE)

Patch for the FreeBSD `acpi_video.ko` kernel module. Fixes brightness control on IdeaPad laptops where the ACPI video device uses a non-standard DOD device ID but still exposes a `_BCL` method. The patch adds a fallback to enumerate those devices.

## Download

Pre-built modules are on the [Releases page](https://github.com/tevarindol/ideapad-brightness-fix/releases).

To install:
```
cp acpi_video-15.1.ko /boot/modules/acpi_video.ko
```

Then load the module:
```
kldload /boot/modules/acpi_video.ko
```

## Building from source

Requires FreeBSD with the full kernel source tree.

```
make clone      # shallow-clone FreeBSD source tree
make build      # clone + patch + compile acpi_video.ko
make install    # copy to /boot/modules/ (needs root)
make distclean  # remove source tree and build artifacts
```

`make build` configures the module against the GENERIC kernel config (`config(8)` +
`KERNBUILDDIR`), so the `.ko` carries the same kernel options as the stock one —
including evdev support, which the brightness hotkeys need.

To build against a different FreeBSD branch:
```
make build BRANCH=releng/14.2
```

## License

BSD-2-Clause. See [LICENSE](LICENSE) for details.
