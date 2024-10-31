{
  description = "QB64";

  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs/nixos-22.11;
    flake-utils.url = github:numtide/flake-utils;
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        buildInputs = with pkgs; [ libGLU xorg.libX11 ];
      in
      {
        packages.default = pkgs.stdenv.mkDerivation rec {
          name = "qb64";
          src = self;
          inherit buildInputs;
          buildPhase = ''
            patchShebangs setup_lnx.sh
            ./setup_lnx.sh
          '';
          installPhase = ''
            mkdir -p $out/bin
            install qb64 $out/bin
          '';
        };
        devShell = with pkgs; mkShell { inherit buildInputs; };
      });
}
