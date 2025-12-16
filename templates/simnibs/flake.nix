{
  description = "Python with SimNIBS";

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
            python311
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
