{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [ kubernetes-helm ];

  fileSystems."/export" = {
    device = "/kube-store";
    options = [ "bind" ];
  };

  services.nfs.server.enable = true;
  services.nfs.server.exports = ''
    /export         10.0.0.0/24(rw,fsid=0,no_subtree_check,crossmnt,no_root_squash)
  '';
}
