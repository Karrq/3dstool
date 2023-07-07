{
  inputs = {
    # Nix Utils
    nixpkgs.url = "nixpkgs/nixos-22.11";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems =
        [ "x86_64-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin" ];
      perSystem = { self', inputs', pkgs, ... }:
        let
          _3dstool = pkgs.stdenv.mkDerivation {
            pname = "3dstool";
            version = "1.2.6";
            src = ./.;

            doCheck = false;
            nativeBuildInputs = with pkgs; [ cmake ];
            buildInputs = with pkgs; [ curl openssl libiconv ];
          };
        in {
          packages.tool3ds = _3dstool;
          packages.default = self'.packages.tool3ds;

          devShells.default = pkgs.mkShell { inputsFrom = [ _3dstool ]; };
        };
    };
}
