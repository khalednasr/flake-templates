{
  description = "Python with SimNIBS";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-python.url = "github:cachix/nixpkgs-python";
    flake-utils.url = "github:numtide/flake-utils";
  };

  nixConfig = {
    extra-substituters = [
      "https://nixpkgs-python.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nixpkgs-python.cachix.org-1:hxjI7pFxTyuTHn2NkvWCrAUcNZLNS3ZAvfYNuYifcEU="
    ];
  };

  outputs = { nixpkgs, nixpkgs-python, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let 
        pkgs = import nixpkgs { inherit system; config.allowUnfree = true; }; 
        pythonVersion = "3.11.0";
      in
      {
        devShells.default = with pkgs; mkShell {
          packages = [
            nixpkgs-python.packages.${system}.${pythonVersion}
            uv
            gcc
            ninja  # For building python-mumps
            gmsh
          ];

          # Native library dependencies
          LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath [
            # Numpy dependencies
            stdenv.cc.cc
            zlib

            # PySide6 dependencies; for matplotlib qtagg backend
            zstd
            dbus
            libGL
            glib
            fontconfig
            freetype
            xorg.libX11
            xorg.libxcb
            xorg.xcbutilwm
            xorg.xcbutilimage
            xorg.xcbutil
            xorg.xcbutilkeysyms
            xorg.xcbutilrenderutil
            xcb-util-cursor
            libxkbcommon

            # SimNIBS dependencies
            mkl
            cgal
            mpfr
            gmp
            libwebp
            mesa
            libGL
            freeglut
          ];

          nativeBuildInputs = [
            mumps-mpi  # for building python-mumps
          ];

          # For matplotlib qtagg backend
          QT_QPA_PLATFORM = "xcb";

          shellHook = ''
            if [ ! -f ./.venv/bin/activate ]; then
              uv sync
            fi
            source ./.venv/bin/activate
          '';
        };
      }
    );
}
