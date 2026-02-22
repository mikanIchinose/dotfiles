{
  description = "mikan m1 mac-book-pro nix-darwin system flake";

  nixConfig = {
    extra-substituters = [ "https://cache.numtide.com" ];
    extra-trusted-public-keys = [ "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g=" ];
  };

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
    flake-parts.url = "github:hercules-ci/flake-parts";
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    systems.url = "github:nix-systems/default";
    llm-agents.url = "github:numtide/llm-agents.nix";
  };

  outputs =
    inputs@{
      self,
      nix-darwin,
      rust-overlay,
      home-manager,
      treefmt-nix,
      flake-parts,
      systems,
      llm-agents,
      ...
    }:
    let
      username = "mikan";
      system = "aarch64-darwin";
      overlays-configuration =
        { pkgs, ... }:
        {
          nixpkgs.overlays = [
            # rust
            rust-overlay.overlays.default
            # neovim nightly
            inputs.neovim-nightly-overlay.overlays.default
            # llm agents
            llm-agents.overlays.default
            # local packages
            (final: prev: {
              gwq = final.callPackage ./nix/packages/gwq { };
              slack-reminder = final.callPackage ./nix/packages/slack-reminder { };
              mocword = final.callPackage ./nix/packages/mocword { };
              rogcat = final.callPackage ./nix/packages/rogcat { };
              covpeek = final.callPackage ./nix/packages/covpeek { };
              copilot-language-server = final.callPackage ./nix/packages/copilot-language-server { };
              gh-actions-language-server = final.callPackage ./nix/packages/gh-actions-language-server { };
              gh-switch-issue = final.callPackage ./nix/packages/gh-switch-issue { };
            })
          ];
          environment.systemPackages = [ pkgs.rust-bin.stable.latest.default ];
        };
    in
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = import systems;
      imports = [ treefmt-nix.flakeModule ];
      flake = {
        darwinConfigurations = {
          mikan = nix-darwin.lib.darwinSystem {
            specialArgs = {
              inherit self system username;
            };
            modules = [
              ./nix/nix-darwin.nix
              home-manager.darwinModules.home-manager
              overlays-configuration
            ];
          };
        };
      };
      perSystem =
        { pkgs, ... }:
        {
          packages.gwq = pkgs.callPackage ./nix/packages/gwq { };
          packages.covpeek = pkgs.callPackage ./nix/packages/covpeek { };
          packages.slack-reminder = pkgs.callPackage ./nix/packages/slack-reminder { };
          packages.gh-switch-issue = pkgs.callPackage ./nix/packages/gh-switch-issue { };
          packages.mocword = pkgs.callPackage ./nix/packages/mocword { };
          packages.rogcat = pkgs.callPackage ./nix/packages/rogcat { };
          packages.copilot-language-server = pkgs.callPackage ./nix/packages/copilot-language-server { };
          packages.gh-actions-language-server =
            pkgs.callPackage ./nix/packages/gh-actions-language-server
              { };
          devShells.default = pkgs.mkShell {
            packages = with pkgs; [
              git
              gh
              jq
              shellcheck
              nix-update
              prefetch-npm-deps
              nix-diff
            ];
          };
          treefmt = {
            projectRootFile = "flake.nix";
            programs = {
              nixfmt.enable = true;
            };
          };
        };
    };
}
