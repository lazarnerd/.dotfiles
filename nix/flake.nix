{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    agenix.url = "github:ryantm/agenix";
    vscode-server.url = "github:nix-community/nixos-vscode-server";
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # home-manager = {
    #   url = "github:nix-community/home-manager";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
  };

  outputs = {
    self,
    agenix,
    disko,
    nixpkgs,
    vscode-server,
    ...
  } @ inputs: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs;};
      modules = [
        ./hosts/acer
        # inputs.home-manager.nixosModules.default

        vscode-server.nixosModules.default
        ({ config, pkgs, ... }: {
          services.vscode-server.enable = true;
        })

        inputs.disko.nixosModules.disko
        agenix.nixosModules.default
        { environment.systemPackages = [ agenix.packages.x86_64-linux.default ]; }
      ];
    };
  };
}
