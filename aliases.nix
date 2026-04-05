{ pkgs, ... }:
{
  programs.fish = {
    enable = true;

    shellAliases = {
      nrb = "sudo nixos-rebuild switch --flake /etc/nixos --impure";
      ni = "nvim /etc/nixos/configuration.nix";
      bat = "upower -i /org/freedesktop/UPower/devices/battery_BAT0| grep -E 'state|percentage'";
      gpu = "nvidia-smi -q | grep -i 'draw.*W'";
      wifi = "sudo nmtui";
      all = "sudo chmod -R a+rwx ./*";
      ng = "cd /etc/nginx/ && sudo nvim .";
      copy = "xclip -sel clip";
      pubkey = "cat ~/.ssh/id_ed25519.pub | ${pkgs.osc}/bin/osc copy";
      up = "docker compose up -d";
      down = "docker compose down -t 0";
      inspect = "nix edit nixpkgs#$1";
      fe = "nix develop";
      fed = "nvim flake.nix";
      cdn = "cd /etc/nixos";
      snorre = "ssh bot@spoodythe.one";
      kube-vm = "ssh -o 'UserKnownHostsFile=/dev/null' -o 'StrictHostKeyChecking=no' root@10.0.0.3";
      kube-vm2 = "ssh -o 'UserKnownHostsFile=/dev/null' -o 'StrictHostKeyChecking=no' -p 2223 root@localhost";
      kube-daddy = "ssh -o 'UserKnownHostsFile=/dev/null' -o 'StrictHostKeyChecking=no' root@10.0.0.2";
      cpu = "sudo turbostat --quiet --show PkgWatt --interval 1 --num_iterations 1 | awk 'NR==2{print $1}'";
      r = "nix run";
      wipe = "sudo rm -fr /var/lib/microvms/kube-* || sudo rm -fr /var/lib/microvms/shared/kube";
      wg-keys = "wg genkey > privatekey && wg pubkey < privatekey > publickey";
      k = "kubectl";

    };

    interactiveShellInit = ''
      function enter
        if test (count $argv) -lt 1
          echo "usage: enter <container-name-or-id>"
            return 1
          end
        docker exec -it $argv[1] sh
            end
    '';
  };
}
