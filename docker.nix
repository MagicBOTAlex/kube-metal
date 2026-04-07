{ config, lib, pkgs, ... }: {
  virtualisation.docker.enableNvidia = true;
  virtualisation.docker.enable = true;
  hardware.nvidia-container-toolkit = {
    enable = true;
    mount-nvidia-executables = true;
    mount-nvidia-docker-1-directories = true;
    extraArgs = [ "--device-name-strategy=uuid" ];
  };

  environment.systemPackages = with pkgs; [ nvidia-docker (lib.getOutput "tools" config.hardware.nvidia-container-toolkit.package) runc ];
  services.envfs.enable = true;
  virtualisation.docker.daemon.settings.features.cdi = true;

  virtualisation.containerd = {
    enable = true;
    settings = {
      plugins = {
        "io.containerd.grpc.v1.cri" = {
          # enable_cdi = true;
          # cdi_spec_dirs = [ "/etc/cdi" "/var/run/cdi" ];
          containerd = {
            # default_runtime_name = "runc";
            runtimes.runc.options = { SystemdCgroup = false; };
            default_runtime_name = "nvidia";
            runtimes = {
              nvidia = {
                privileged_without_host_devices = false;
                runtime_type = "io.containerd.runc.v2";
                options = {
                  BinaryName = "${lib.getOutput "tools" config.hardware.nvidia-container-toolkit.package}/bin/nvidia-container-runtime";
                };
              };
            };
          };
        };
      };
    };
  };

  # Tell the Kubelet to use containerd
  services.kubernetes.kubelet.containerRuntimeEndpoint = "unix:///run/containerd/containerd.sock";
}
