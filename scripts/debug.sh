#!/usr/bin/env sh
set -e

case "$1" in
  server)
    openocd -f interface/stlink.cfg -f target/stm32f0x.cfg
    ;;
  gdb)
    arm-none-eabi-gdb build/app/icp-fw-app \
      -ex "target remote :3333"
    ;;
esac
