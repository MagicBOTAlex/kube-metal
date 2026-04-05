{ config, pkgs, ... }:

{
  # Ensure the necessary tools are installed
  environment.systemPackages = [ pkgs.wireguard-tools ];

  boot.kernel.sysctl."net.ipv4.ip_forward" = 1;

  systemd.services.wireguard-kube = {
    description = "WireGuard VPN Service for kube-wg";

    # Ensure the service starts after the network is up
    after = [
      "network.target"
      "network-online.target"
    ];
    wants = [ "network-online.target" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;

      # Use wg-quick to setup and teardown the interface
      ExecStart = "${pkgs.wireguard-tools}/bin/wg-quick up /etc/wireguard/wireguard-kube.conf";
      ExecStop = "${pkgs.wireguard-tools}/bin/wg-quick down /etc/wireguard/wireguard-kube.conf";
      CapabilityBoundingSet = "CAP_NET_ADMIN CAP_NET_RAW";
    };
  };
}
