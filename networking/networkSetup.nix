{ pkgs, ... }: {
  services.caddy = { enable = true; };

  security.acme.acceptTerms = true;
  security.acme.defaults.email = "zhen@deprived.dev";
  networking.firewall.enable = false;

  networking.useNetworkd = true;
  networking.useDHCP = false;

  systemd.network.enable = true;
  systemd.network.networks."10-enp8s0" = {
    matchConfig.Name = "enp8s0";
    networkConfig.DHCP = "ipv4";
    dhcpV4Config.UseRoutes = true;
  };
}
