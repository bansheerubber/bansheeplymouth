{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
        libraries = [ ];
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = libraries;
        };

        packages.default = pkgs.stdenv.mkDerivation {
          pname = "bansheeplymouth";
          version = "0.1.0";

          src = ./theme; 

          dontBuild = true;

          installPhase = ''
            runHook preInstall

            mkdir -p $out/share/plymouth/themes/bansheeplymouth
            cp -r * $out/share/plymouth/themes/bansheeplymouth/

            # Correct paths inside the plymouth script/config to point to the nix store
            find $out/share/plymouth/themes/bansheeplymouth -name "*.plymouth" -exec sed -i "s|/usr/share/plymouth/themes|$out/share/plymouth/themes|g" {} +

            runHook postInstall
          '';
        };
      }
    );
}
