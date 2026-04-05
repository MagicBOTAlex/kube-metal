{ pkgs, lib, fetchFromGitHub, wireguard-tools, makeWrapper, stdenv, ... }:
let
  version = "1.1";
  wgmesh-unwrapped = pkgs.buildGoModule rec {
    name = "wgmesh-unwrapped";
    inherit version;

    src = fetchFromGitHub {
      owner = "Dan-J-D";
      repo = "wgmesh";
      tag = "v${version}";
      hash = "sha256-7CXTyvCD4ywRZE0xTc3BbU6Ze72KQ2Q25qHl3LjBO28=";
    };

    vendorHash = "sha256-JGaaQ+y+hbO5eBm51Wxj8u8AMdfXN9pKWIdYxPr2Ix8=";

    meta.mainProgram = "wgmesh";
  };

  binPath = lib.makeBinPath [ wireguard-tools ];
in stdenv.mkDerivation rec {
  name = "wgmesh";
  inherit version;

  nativeBuildInputs = [ makeWrapper ];

  buildCommand = ''
    makeWrapper ${lib.getExe wgmesh-unwrapped} $out/bin/${name} \
      --suffix-each PATH ':' "${binPath}"
  '';

  meta.mainProgram = "wgmesh";
}
