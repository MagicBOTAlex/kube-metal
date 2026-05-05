{ config, lib, pkgs, ... }:
let
  nvidiaEnabled = builtins.elem "nvidia" config.services.xserver.videoDrivers;
in
{
  config = lib.mkMerge [
    (lib.mkIf nvidiaEnabled {
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
    })
    (lib.mkIf (!nvidiaEnabled) {
      virtualisation.containerd = {
        enable = true;
        settings = {
          version = 2;
          plugins."io.containerd.grpc.v1.cri" = {
            # This is the critical part for Kubeadm
            containerd.runtimes.runc = {
              runtime_type = "io.containerd.runc.v2";
              options.SystemdCgroup = true;
            };

            # # Keep your existing settings
            # containerd.snapshotter = lib.mkIf config.boot.zfs.enabled (lib.mkOptionDefault "zfs");
            # cni.bin_dir = lib.mkOptionDefault "${pkgs.cni-plugins}/bin";
          };
        };
      };
    })
  ];


  # # Tell the Kubelet to use containerd
  # services.kubernetes.kubelet.containerRuntimeEndpoint = "unix:///run/containerd/containerd.sock";
}
