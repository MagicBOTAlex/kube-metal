{ pkgs, lib, ... }: {
  imports = [ ./modules/nvim.nix ];

  # packages only for this user
  home.packages = [ ];

  # env variables for this user
  home.sessionVariables = {
    EDITOR = "nvim"; # use nvim as editor
  };

  home.stateVersion = "25.11";
}
