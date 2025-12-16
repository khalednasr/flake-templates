{
  description = "Basic flake template";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = import nixpkgs { inherit system; config.allowUnfree = true; }; in
      {
        devShells.default = with pkgs; mkShell {
          packages = [
            cowsay 
          ];

          # Native library dependencies
          LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath [
          ];

          shellHook = ''
            cowsay "Moooo!"
          '';
        };
      }
    );
}
