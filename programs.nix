{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    neovim
    wget
    iproute2
    curl
    fastfetch
    tree
    btop-cuda
    pigz
    ncdu
    screen
    nixfmt-tree
    ffmpeg-full
    borgbackup
    openssl
    wireguard-tools
    apacheHttpd
    p7zip
    kubectl
    lua5_1
    jq
    luarocks
    vtk
    immich-cli
    parted
    toybox
    gitoxide
    (pkgs.callPackage ./modules/customPackages/shreddit/shreddit.nix { })
    busybox
    linuxKernel.packages.linux_6_12.turbostat
    linuxKernel.packages.linux_6_12.cpupower
ripgrep
  ];

  programs.starship.enable = true;
}
