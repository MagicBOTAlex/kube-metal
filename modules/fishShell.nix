{ pkgs, ... }:
{
  programs.fish.enable = true;
  documentation.man.generateCaches = false;

  users.users."metal".shell = pkgs.fish;
  users.users.root.shell = pkgs.fish;
}
