set -e

lsblk -o NAME
read -p "Enter disk to partition: " DISKNAME
DISKDEVICE="/dev/$DISKNAME"
printf "label: gpt\n,1024M,U\n,,L\n" | sfdisk $DISKDEVICE

PARTITIONS=$(lsblk -J -o NAME $DISKDEVICE | jq -r '.blockdevices[0].children[].name' | tr '\n' ' ')

read -a PARTITIONS <<< "$PARTITIONS"
BOOT_PARTITION="/dev/${PARTITIONS[0]}"
BTRFS_PARTITION="/dev/${PARTITIONS[1]}"

mkfs.fat -F 32 ${BOOT_PARTITION}
mkfs.btrfs ${BTRFS_PARTITION}

mkdir -p /mnt
mount ${BTRFS_PARTITION} /mnt
btrfs subvolume create /mnt/swap
btrfs subvolume create /mnt/ssh
btrfs subvolume create /mnt/downloads
btrfs subvolume create /mnt/workspaces

btrfs subvolume create /mnt/nixos
btrfs subvolume create /mnt/nixos/root
btrfs subvolume create /mnt/nixos/nix
btrfs subvolume create /mnt/nixos/home

umount /mnt

mount -o subvol=nixos/root ${BTRFS_PARTITION} /mnt
mkdir -p /mnt/{boot,home,nix,swap}
mount -o subvol=nixos/nix ${BTRFS_PARTITION} /mnt/nix
mount -o subvol=nixos/home ${BTRFS_PARTITION} /mnt/home
mount -o subvol=swap ${BTRFS_PARTITION} /mnt/swap
mkdir -p /mnt/home/nerd/{.ssh,Downloads,workspaces}
mount -o subvol=ssh ${BTRFS_PARTITION} /mnt/home/nerd/.ssh
mount -o subvol=downloads ${BTRFS_PARTITION} /mnt/home/nerd/Downloads
mount -o subvol=workspaces ${BTRFS_PARTITION} /mnt/home/nerd/workspaces
mount ${BOOT_PARTITION} /mnt/boot

btrfs filesystem mkswapfile --size 8g --uuid clear /mnt/swap/swapfile

git clone git@github.com:lazarnerd/.dotfiles.git /mnt/home/nerd/.dotfiles
nixos-generate-config --root /mnt --show-hardware-config > /mnt/home/nerd/.dotfiles/nix/hosts/default/hardware-configuration.nix
sudo chown -R 1000:100 /mnt/home/nerd

nixos-install --root /mnt --flake /mnt/home/nerd/.dotfiles/nix
