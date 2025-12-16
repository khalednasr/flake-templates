{
  description = "Python with uv package management";

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
            python314  # Change python version here
            uv
          ];

          # Native library dependencies
          LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath [
            # Numpy dependencies
            stdenv.cc.cc
            libz

            # PySide6 dependencies; for matplotlib qtagg backend
            dbus
            libGL
            glib
            zlib
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

            # CUDA and nvidia driver for PyTorch
            # cudatoolkit linuxPackages.nvidia_x11
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
