{ pkgs, ... }: {
  services.harmonia = {
    enable = true;
    signKeyPaths = [ "/var/lib/secrets/harmonia.secret" ];
    settings = {
      bind = "0.0.0.0:5444";
      workers = 4;
    };
  };

  nix.settings.trusted-users = [ "root" "metal" ];

  imports = [ ./../networking/networkSetup.nix ];

  services.caddy = {
    enable = true;
    virtualHosts."cache.deprived.dev" = {
      extraConfig = ''
        reverse_proxy localhost:5444

        header {
          # Cache control for nix store paths
          Cache-Control "public, max-age=31536000, immutable"
          
          # CORS headers if needed
          Access-Control-Allow-Origin "*"
          Access-Control-Allow-Methods "GET, HEAD, OPTIONS"
        }

        # Optional: Enable compression
        encode gzip

        # Optional: Logging
        log {
          output file /var/log/caddy/cache.log
        }
      '';
    };
  };
}
