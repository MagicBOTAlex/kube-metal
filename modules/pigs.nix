{ pkgs, ... }: {
  environment.variables.GZIP = "pigz";
  environment.systemPackages = with pkgs; [ pigz ];
}

