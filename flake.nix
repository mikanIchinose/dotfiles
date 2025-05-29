{
  description = "mikan m1 mac-book-pro nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };
    homebrew-bundle = {
      url = "github:homebrew/homebrew-bundle";
      flake = false;
    };
    homebrew-fvm = {
      url = "github:leoafarias/homebrew-tap";
      flake = false;
    };
    homebrew-macskk = {
      url = "github:mtgto/homebrew-macSKK";
      flake = false;
    };
    homebrew-aerospace = {
      url = "github:nikitabobko/homebrew-tap";
      flake = false;
    };
    homebrew-takahirom = {
      url = "github:takahirom/homebrew-repo";
      flake = false;
    };
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
      nix-homebrew,
      homebrew-core,
      homebrew-cask,
      homebrew-bundle,
      homebrew-fvm,
      homebrew-macskk,
      homebrew-aerospace,
      homebrew-takahirom,
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
              sudo nix run nix-darwin -- switch --flake .#mikan
              rm -rf ~/.cache/dpp/nvim/
              echo "Update done!"
            ''
          );
        };
      };
      darwinConfigurations.mikan = nix-darwin.lib.darwinSystem {
        specialArgs = {
          inherit inputs self system;
        };
        modules = [
          nix-homebrew.darwinModules.nix-homebrew
          {
            nix-homebrew = {
              enable = true;
              enableRosetta = true;
              user = "mikan";
              taps = {
                "homebrew/homebrew-core" = homebrew-core;
                "homebrew/homebrew-cask" = homebrew-cask;
                "homebrew/homebrew-bundle" = homebrew-bundle;
                "leoafarias/homebrew-tap" = homebrew-fvm;
                "mtgto/homebrew-macSKK" = homebrew-macskk;
                "nikitabobko/homebrew-tap" = homebrew-aerospace;
                "takahirom/homebrew-repo" = homebrew-takahirom;
              };
              mutableTaps = false;
            };
          }
          ./nix/nix-darwin.nix
          (
            { pkgs, ... }:
            {
              nixpkgs.overlays = [ rust-overlay.overlays.default ];
              environment.systemPackages = [ pkgs.rust-bin.stable.latest.default ];
            }
          )
        ];
      };
      homeConfigurations = {
        myHomeConfig = home-manager.lib.homeManagerConfiguration {
          pkgs = pkgs;
          extraSpecialArgs = {
            inherit inputs;
          };
          modules = [
            ./nix/home-manager.nix
          ];
        };
      };
    };
}
