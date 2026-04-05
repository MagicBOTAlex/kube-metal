{ config, pkgs, lib, ... }:
let
  oscd = pkgs.rustPlatform.buildRustPackage rec {
    pname = "oscd";
    version = "0.1.10";

    src = pkgs.fetchCrate {
      inherit pname version;
      hash = "sha256-PMn7PB7Mt+YrpV0bohTIAVvBOZMigV7WdJjwNEGpbgs=";
    };

    cargoHash = "sha256-K6eyRyBdab3/7024LNTh5SETH1gMZjB9viFzzWLdYBc=";

    meta = with lib; {
      description = "OSC debugger (CLI)";
      homepage = "https://crates.io/crates/oscd";
      license = licenses.mit;
      maintainers = with maintainers; [ ];
      platforms = platforms.all;
    };
  };
in
{ environment.systemPackages = with pkgs; [ oscd ]; }

