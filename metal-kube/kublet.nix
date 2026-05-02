{ pkgs, ... }:

{
  systemd.services.kubelet = {
    description = "kubelet: The Kubernetes Node Agent";
    documentation = [ "https://kubernetes.io/docs/home/" ];

    # Unit requirements
    wants = [ "network-online.target" ];
    after = [ "network-online.target" ];

    serviceConfig = {
      # Use the kubelet binary from the Nix store
      ExecStart = "${pkgs.kubernetes}/bin/kubelet";

      Restart = "always";
      RestartSec = 10;
    };

    # Systemd 230+ uses StartLimitIntervalSec in the [Unit] section
    unitConfig = {
      StartLimitIntervalSec = 0;
    };

    # Equivalent to [Install] WantedBy
    wantedBy = [ "multi-user.target" ];
  };
}
