{ config, lib, pkgs, ... }:

{
  programs.git = {
    enable = true;
    config = {
      user.name = "Daniel Neururer";
      user.email = "danielxiv64@gmail.com";
    };
  };
  
  environment.systemPackages = [
    pkgs.lazygit
  ];
}
