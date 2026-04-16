{ config, pkgs, ... }:
let
  kubeMasterIP = "176.23.63.215";
  kubeMasterHostname = "clussy.deprived.dev";
  kubeMasterAPIServerPort = 6443;
in
{
  imports = [ ];

  # resolve master hostname
  networking.extraHosts = ''
    ${kubeMasterIP} ${kubeMasterHostname}
    10.0.0.2 kube-daddy
    10.0.0.4 kube-desk
    10.0.0.5 kube-snorre
    10.0.0.8 kube-metal
  '';
  networking.firewall.enable = false;

  # packages for administration tasks
  environment.systemPackages = with pkgs; [ kompose kubectl kubernetes kubernetes-helm nfs-utils];

  systemd.services.kube-networking-fix = {
    description = "fucking, networking - IP cleanup and WireGuard start";

    # Ensure we wait for the physical interface to actually be up
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      Type = "oneshot";
      # 1. Force remove the IP from enp0s7 if it exists (ignores error if already gone)
      # 2. Force remove the route if it exists
      # 3. Bring up the WireGuard interface
      ExecStart = pkgs.writeScript "fix-net.sh" ''
        #!${pkgs.stdenv.shell}
        # echo "Cleaning up conflicting routes and IPs..."
        # ${pkgs.iproute2}/bin/ip addr del 10.0.0.4/24 dev enp0s7 2>/dev/null || true
        # ${pkgs.iproute2}/bin/ip route del 10.0.0.0/24 dev enp0s7 2>/dev/null || true
      
        echo "Bringing up WireGuard tunnel..."
        ${pkgs.wireguard-tools}/bin/wg-quick up wireguard-kube
      '';

      # Properly tear down the tunnel when the service stops or system reboots
      ExecStop = "${pkgs.wireguard-tools}/bin/wg-quick down wireguard-kube";

      RemainAfterExit = true;
      User = "root";
    };

    # This ensures that if you change the config, it runs ExecStop then ExecStart
    stopIfChanged = true;
  };

  services.resolved.enable = true;
  services.flannel.iface = "wireguard-kube";

  services.kubernetes =
    let
      api = "https://${kubeMasterHostname}:${toString kubeMasterAPIServerPort}";
    in
    {
      roles = [ "node" ];
      masterAddress = kubeMasterHostname;
      easyCerts = true;

      # point kubelet and other services to kube-apiserver
      kubelet.kubeconfig.server = api;
      apiserverAddress = api;

      # use coredns
      addons.dns.enable = true;

      flannel.enable = true;


      # needed if you use swap
      kubelet.extraOpts = "--fail-swap-on=false --node-ip=10.0.0.8 ";
    };
}


