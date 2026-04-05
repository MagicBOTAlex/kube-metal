{ config, pkgs, ... }:

{
  systemd.services.blank-tty1 = {
    description = "Blank the active console (defaults to tty1)";
    wants = [ "getty@tty1.service" ];
    after  = [ "getty@tty1.service" ];
    unitConfig.ConditionPathExists = "/dev/tty1";

    # Put `setterm` in PATH
    path = [ pkgs.kbd ];

    serviceConfig = {
      Type = "oneshot";
    };

    # Do exactly what worked for you, with a small fallback
    script = ''
      set -e

      # Prefer the active VT if available; otherwise use tty1
      TTY="$(cat /sys/class/tty/tty0/active 2>/dev/null || echo tty1)"

      # Try setterm on that TTY (same redirections as your manual command)
      if ! setterm --term linux --blank force </dev/"$TTY" >/dev/"$TTY" 2>/dev/null; then
        # Fallback: ask the framebuffer to blank (driver-dependent)
        for fb in /sys/class/graphics/fb*/blank; do
          [ -w "$fb" ] && echo 1 > "$fb" && break
        done
      fi
    '';
  };

  systemd.timers.blank-tty1 = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnActiveSec = "30s";   # 30s after the timer is activated at boot
      AccuracySec = "1s";
      Persistent  = true;
      Unit        = "blank-tty1.service";
    };
  };
}

