ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/.."
NIX_DIR="$ROOT_DIR/nix"
nix --experimental-features "nix-command flakes" run github:nix-community/disko/latest -- --mode destroy,format,mount --yes-wipe-all-disks $NIX_DIR/hosts/acer/disko.nix

cp -R $ROOT_DIR /mnt/home/nerd/.dotfiles
cp -R $ROOT_DIR/.ssh/* /mnt/home/nerd/.ssh

chown -R 1000:100 /mnt/home/nerd
chmod 700 /mnt/home/nerd/.ssh
chmod 600 /mnt/home/nerd/.ssh/*

nixos-install --flake "$NIX_DIR/flake.nix#acer"
