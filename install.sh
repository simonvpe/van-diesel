#!/usr/bin/env bash
set -o nounset -o errexit -o xtrace

readonly device="${1}"

nix-shell --run "sudo parted --script ${device} \
  mklabel gpt \
  mkpart primary fat32 8192s 512MiB \
  mkpart primary ext4 512MiB 100% \
  quit
"

sync
nix-shell --run "sudo mkfs.vfat -n BOOT ${device}p1"
nix-shell --run "sudo mkfs.ext4 -F -L ROOT ${device}p2"


mkdir -p system-info
nix-shell --run "sudo blkid '${device}p1' -sUUID -ovalue" > system-info/boot-uuid
nix-shell --run "sudo blkid '${device}p2' -sUUID -ovalue" > system-info/root-uuid

nix-build
nixos-install --system $(readlink result)

