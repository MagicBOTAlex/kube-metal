{ pkgs, ... }: {
  virtualisation.docker.enable = true;

  hardware.nvidia-container-toolkit.enable = true;

  systemd.user.services.force-start-docker-containers = {
    description = "docker stupid, so this starts the docker composes";

    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      ExecStart = "/home/botserver/scripts/docker/up.sh";
      Type = "oneshot";
    };
  };
}
