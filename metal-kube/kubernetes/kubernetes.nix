{ pkgs, ... }: {
  imports = [ ./kubelet.nix ./containerd.nix ];
  environment.systemPackages = with pkgs; [ kubernetes cri-tools ];
}
