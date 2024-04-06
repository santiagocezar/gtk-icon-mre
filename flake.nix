{
  inputs = {
    naersk = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/naersk/master";
    };
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, utils, naersk }:
    utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        naersk-lib = pkgs.callPackage naersk { };
        deps = with pkgs; [ gtk4 libadwaita ];
        buildDeps = with pkgs; [ pkg-config ] ++ deps;
      in
      {
        defaultPackage = naersk-lib.buildPackage {
          src = ./.;
          nativeBuildInputs = buildDeps;
          buildInputs = deps;
        };
        devShell = with pkgs; mkShell {
          buildInputs = [ cargo rustc rustfmt pre-commit rustPackages.clippy rust-analyzer ] ++ buildDeps;
          RUST_SRC_PATH = rustPlatform.rustLibSrc;
        };
      });
}
