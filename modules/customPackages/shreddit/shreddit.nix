{ lib, pkgs, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "shreddit";
  version = "1.1.1"; # pick the crate version you want

  src = pkgs.fetchCrate {
    inherit pname version;
    sha256 =
      "sha256-ERcQZ7LLR9kfI1WMCr70EopmuPmK4Y7eXnhM7djvEI4="; # fill after first build
  };

  cargoHash =
    "sha256-9s6wmB4YqKmyHKDS2b5keEYFDBerpdQxtNY1wVqGDxg="; # fill after first build

  nativeBuildInputs = [ pkgs.pkg-config ];
  buildInputs = [ pkgs.openssl ];

  meta = with lib; {
    description = "Shreddit CLI (Rust crate)";
    license = licenses.mit; # adjust if needed
    mainProgram = "shreddit";
  };
}

