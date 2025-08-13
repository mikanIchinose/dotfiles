{
  description = "mikan m1 mac-book-pro nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
  };

  outputs =
    inputs@{
      self,
      nix-darwin,
      nixpkgs,
      rust-overlay,
      home-manager,
      ...
    }:
    let
      system = "aarch64-darwin";
      pkgs = import nixpkgs { inherit system; };
    in
    {
      apps.${system} = {
        update = {
          type = "app";
          program = toString (
            pkgs.writeShellScript "update-script" ''
              set -e
              echo "Update flake..."
              nix flake update
              echo "Updating home-manager..."
              nix run nixpkgs#home-manager -- switch --flake .#myHomeConfig
              echo "Updating nix-darwin..."
              sudo nix run nix-darwin/master#darwin-rebuild -- switch --flake .#mikan
              rm -rf ~/.cache/dpp/nvim
              echo "Update done!"
            ''
          );
        };
      };
      darwinConfigurations.mikan = nix-darwin.lib.darwinSystem {
        specialArgs = {
          inherit self system;
        };
        modules = [
          ./nix/nix-darwin.nix
          home-manager.darwinModules.home-manager
          #(
          #  { pkgs, ... }:
          #  {
          #    nixpkgs.overlays = [ rust-overlay.overlays.default ];
          #    environment.systemPackages = [ pkgs.rust-bin.stable.latest.default ];
          #  }
          #)
        ];
      };
      homeConfigurations = {
        myHomeConfig = home-manager.lib.homeManagerConfiguration {
          pkgs = pkgs;
          extraSpecialArgs = {
            inherit inputs system;
          };
          modules = [
            ./nix/home-manager.nix
          ];
        };
      };
    };
}
