# Disk

## e.g.: /dev/sda
DISK=/dev/nvme0n1
## e.g.: 1 for /dev/sda1
PART=1
## e.g.: 9f8ede5b-3e0d-4994-b0a3-6e14f6c2e379
UUID=9f8ede5b-3e0d-4994-b0a3-6e14f6c2e379

# Boot entry

## Label in boot menu
LABEL="Arch Linux"
## Kernel args
BOOTARGS="rw quiet iommu=soft idle=nowait"

# Kernel / microcode

## e.g.: \\amd-ucode.img or \\intel-ucode.img
MICROCODE=\\amd-ucode.img
## e.g.: linux, linux-lts, linux-ck, etc..
KERNEL=linux-ck-zen
LOADER=/vmlinuz-$KERNEL
RAMFS=\\initramfs-$KERNEL.img

# command
COMMANDARGS="--disk $DISK --part $PART --create --label '$LABEL' --loader '$LOADER' --unicode 'initrd=$MICROCODE root=UUID=$UUID initrd=$RAMFS $BOOTARGS' --verbose"
COMMAND="efibootmgr $COMMANDARGS"
echo "$COMMAND"
