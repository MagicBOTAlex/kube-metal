{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    nodejs_22
    nodePackages.live-server
    nodePackages.serve
  ];
}
