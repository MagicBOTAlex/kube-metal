{ pkgs, ... }:
{
  imports = [ ./networkSetup.nix ];

  services.caddy.virtualHosts."immich.deprived.dev" = {
    extraConfig = ''
      reverse_proxy * 127.0.0.1:2283
    '';
  };

  services.caddy.virtualHosts."ha.deprived.dev" = {
    extraConfig = ''
      reverse_proxy 127.0.0.1:8123
    '';
  };

  # services.caddy.virtualHosts."argocd.deprived.dev" = {
  #   extraConfig = ''
  #     reverse_proxy https://127.0.0.1:4325 {
  #       header_up Host {host}
  #       transport http {
  #         tls_insecure_skip_verify
  #       }
  #     }
  #   '';
  # };
  services.caddy.virtualHosts."argocd.deprived.dev" = {
    extraConfig = ''
      reverse_proxy * 10.0.0.2:4325
    '';
  };

  services.caddy.virtualHosts."webui.deprived.dev" = {
    extraConfig = ''
      reverse_proxy * 127.0.0.1:3000
    '';
  };

  services.caddy.virtualHosts."yaaumma.com" = {
    extraConfig = ''
      redir https://www.yaaumma.com{uri} permanent
    '';
  };

  services.caddy.virtualHosts."jelly.deprived.dev" = {
    extraConfig = ''
      reverse_proxy * 10.0.0.2:8096
    '';
  };

  services.caddy.virtualHosts."netbird.deprived.dev" = {
    extraConfig = ''
      reverse_proxy * 10.0.0.2:3324
    '';
  };

  services.caddy.virtualHosts."seer.deprived.dev" = {
    extraConfig = ''
      reverse_proxy * 127.0.0.1:5055
    '';
  };

  services.caddy.virtualHosts."penpot.deprived.dev" = {
    extraConfig = ''
      reverse_proxy * 127.0.0.1:5544
    '';
  };
  services.caddy.virtualHosts."akupunktur-herlev.dk" = {
    extraConfig = ''
      redir https://www.akupunktur-herlev.dk{uri} 301
    '';
  };
  services.caddy.virtualHosts."www.akupunktur-herlev.dk" = {
    extraConfig = ''
      reverse_proxy 127.0.0.1:6642 {
         header_up Host {host}
         header_up X-Real-IP {remote_host}
         header_up X-Forwarded-Proto {scheme}
      }
    '';
  };

  services.caddy.virtualHosts."devcam.deprived.dev" = {
    extraConfig = ''
      @protected not method OPTIONS
      basicauth @protected {
        alex $2a$14$GbqQnETcOz5fNEbS06Y0E.HxRIIgPKAK7OMijT1Bv63h3V6S/gwRG
      }

      reverse_proxy * 192.168.50.85:80
    '';
  };

  services.caddy.virtualHosts."api.deprived.dev" = {
    extraConfig = ''
      @allowedOrigin header_regexp Origin ^https?://(localhost(:\d+)?|([a-z0-9-]+\.)*deprived\.dev)$
      	@hasOrigin header Origin *
      	@preflight method OPTIONS

      	@badOrigin {
      		not {
      			header_regexp Origin ^https?://(localhost(:\d+)?|([a-z0-9-]+\.)*deprived\.dev)$
      		}
      		header Origin *
      	}

      	@preflightAllowed {
      		method OPTIONS
      		header_regexp Origin ^https?://(localhost(:\d+)?|([a-z0-9-]+\.)*deprived\.dev)$
      	}

      	# Allowed preflight
      	handle @preflightAllowed {
      		header {
      			Access-Control-Allow-Methods "GET, POST, PUT, PATCH, DELETE"
      			Access-Control-Allow-Headers "{http.request.header.Access-Control-Request-Headers}"
      			Access-Control-Max-Age "3600"
      			Access-Control-Allow-Credentials "true"
      			Access-Control-Allow-Origin "{http.request.header.Origin}"
      			Vary "Origin"
      		}
      		respond "" 204
      	}

      	# Preflight but missing/bad origin
      	handle @preflight {
      		respond "CORS origin not allowed" 403
      	}

      	# Block actual requests with bad origin
      	handle @badOrigin {
      		respond "CORS origin not allowed" 403
      	}

      	# Allowed origins → proxy + always add CORS (even if upstream returns 204)
      	handle @allowedOrigin {
      		reverse_proxy 127.0.0.1:6333 {
      			header_down -Access-Control-*
      			header_down -Vary
      		}
      		header {
      			Access-Control-Allow-Origin "{http.request.header.Origin}"
      			Access-Control-Allow-Credentials "true"
      			Access-Control-Expose-Headers "Authorization"
      			Vary "Origin"
      		}
      	}

      	# No Origin: just proxy
      	handle {
      		reverse_proxy 127.0.0.1:6333
      	}
    '';
  };

  services.caddy.virtualHosts."pocket.deprived.dev" = {
    extraConfig = ''
        @allowedOrigin header_regexp Origin ^https?://(localhost(:\d+)?|([a-z0-9-]+\.)*deprived\.dev)$
      	@hasOrigin header Origin *
      	@preflight method OPTIONS

      	@badOrigin {
      		not {
      			header_regexp Origin ^https?://(localhost(:\d+)?|([a-z0-9-]+\.)*deprived\.dev)$
      		}
      		header Origin *
      	}

      	@preflightAllowed {
      		method OPTIONS
      		header_regexp Origin ^https?://(localhost(:\d+)?|([a-z0-9-]+\.)*deprived\.dev)$
      	}

      	# Allowed preflight
      	handle @preflightAllowed {
      		header {
      			Access-Control-Allow-Methods "GET, POST, PUT, PATCH, DELETE"
      			Access-Control-Allow-Headers "{http.request.header.Access-Control-Request-Headers}"
      			Access-Control-Max-Age "3600"
      			Access-Control-Allow-Credentials "true"
      			Access-Control-Allow-Origin "{http.request.header.Origin}"
      			Vary "Origin"
      		}
      		respond "" 204
      	}

      	# Preflight but missing/bad origin
      	handle @preflight {
      		respond "CORS origin not allowed" 403
      	}

      	# Block actual requests with bad origin
      	handle @badOrigin {
      		respond "CORS origin not allowed" 403
      	}

      	# Allowed origins → proxy + always add CORS (even if upstream returns 204)
      	handle @allowedOrigin {
      		reverse_proxy 127.0.0.1:3433 {
      			header_down -Access-Control-*
      			header_down -Vary
      		}
      		header {
      			Access-Control-Allow-Origin "{http.request.header.Origin}"
      			Access-Control-Allow-Credentials "true"
      			Access-Control-Expose-Headers "Authorization"
      			Vary "Origin"
      		}
      	}

      	# No Origin: just proxy
      	handle {
      		reverse_proxy 127.0.0.1:3433
      	}

    '';
  };

  services.caddy.virtualHosts."spotify.playing.deprived.dev" = {
    extraConfig = ''
      encode zstd gzip

      @preflight method OPTIONS
      handle @preflight {
        header {
          Access-Control-Allow-Origin "{http.request.header.Origin}"
          Access-Control-Allow-Methods "GET, POST, PUT, PATCH, DELETE, OPTIONS"
          Access-Control-Allow-Headers "{http.request.header.Access-Control-Request-Headers}"
          Access-Control-Allow-Credentials "true"
          Access-Control-Max-Age "600"
          Vary "Origin"
        }
        respond 204
      }

      @protected not method OPTIONS
      basicauth @protected {
        alex $2a$14$GbqQnETcOz5fNEbS06Y0E.HxRIIgPKAK7OMijT1Bv63h3V6S/gwRG
      }

      reverse_proxy 127.0.0.1:8800

      header {
        Access-Control-Allow-Origin "{http.request.header.Origin}"
        Access-Control-Allow-Methods "GET, POST, PUT, PATCH, DELETE, OPTIONS"
        Access-Control-Allow-Headers "{http.request.header.Access-Control-Request-Headers}"
        Access-Control-Allow-Credentials "true"
        Vary "Origin"
      }
    '';
  };

  services.caddy.virtualHosts."spotify.api.deprived.dev" = {
    extraConfig = ''
      encode zstd gzip

      # 1. CORS Headers
      # We switched "*" to "{header.Origin}" and added "Credentials: true"
      # This allows the browser to send the Authorization header safely.
      header {
          Access-Control-Allow-Origin "{header.Origin}"
          Access-Control-Allow-Methods "GET, POST, PUT, PATCH, DELETE, OPTIONS"
          Access-Control-Allow-Headers "Origin, X-Requested-With, Content-Type, Accept, Authorization"
          Access-Control-Allow-Credentials "true"
          Vary "Origin"
      }

      # 2. Handle Preflight (OPTIONS)
      # Must be defined before Basic Auth
      @options {
          method OPTIONS
      }
      respond @options 204

      # 3. Protect everything EXCEPT Options
      # (Fix: Ensure this is on a new line)
      @protected {
          not method OPTIONS
      }

      basicauth @protected {
          alex $2a$14$GbqQnETcOz5fNEbS06Y0E.HxRIIgPKAK7OMijT1Bv63h3V6S/gwRG
      }

      # 4. Proxy
      reverse_proxy 127.0.0.1:4142 {
          header_down -Access-Control-Allow-Origin
      }
    '';
  };

  services.caddy.virtualHosts."lyrics.deprived.dev" = {
    extraConfig = ''
      header {
          Access-Control-Allow-Origin "*"
          Access-Control-Allow-Methods "GET, POST, PUT, PATCH, DELETE, OPTIONS"
          Access-Control-Allow-Headers "Origin, X-Requested-With, Content-Type, Accept, Authorization"
      }

      @options {
          method OPTIONS
      }
      respond @options 204

      reverse_proxy * 127.0.0.1:7444
    '';
  };

  # Github MaintainerCD hook
  services.caddy.virtualHosts."lyrics.hook.deprived.dev" = {
    extraConfig = ''
      reverse_proxy * 127.0.0.1:7576
    '';
  };

  services.caddy.virtualHosts."docker.deprived.dev" = {
    extraConfig = ''
      reverse_proxy * 127.0.0.1:5000
    '';
  };

  services.caddy.virtualHosts."docker.ui.deprived.dev" = {
    extraConfig = ''
      reverse_proxy * 127.0.0.1:6842

    '';
  };

  services.caddy.virtualHosts."zhenss.deprived.dev" = {
    extraConfig = ''
      reverse_proxy * 127.0.0.1:8388
    '';
  };

  services.caddy.virtualHosts."zcol.deprived.dev" = {
    extraConfig = ''
      reverse_proxy * 127.0.0.1:7577
    '';
  };

  services.caddy.virtualHosts."zcollection.deprived.dev" = {
    extraConfig = ''
      reverse_proxy * 127.0.0.1:7577
    '';
  };
  services.caddy.virtualHosts."zcollection.mcd.deprived.dev" = {
    extraConfig = ''
      reverse_proxy * 127.0.0.1:7578
    '';
  };

  services.caddy.virtualHosts."direct.stream.deprived.dev" = {
    extraConfig = ''
      @allowKey {
        query key=0c156f3d-dc1d-489f-866e-69e306249e92
      }

      route {
        handle @allowKey {
          reverse_proxy http://127.0.0.1:3344
        }

        respond "Forbidden" 403
      }
    '';
  };

  services.caddy.virtualHosts."development.deprived.dev" = {
    extraConfig = ''
      reverse_proxy * 127.0.0.1:5173
    '';
  };

  services.caddy.virtualHosts."dev.hook.deprived.dev" = {
    extraConfig = ''
      reverse_proxy * 127.0.0.1:3322
    '';
  };

  services.caddy.virtualHosts."internal.deprived.dev" = {
    extraConfig = ''
      # Only allow GET + POST
      @not_allowed {
        not method GET POST
      }
      respond @not_allowed 405

      # Auth (same as before): require auth for non-POST (i.e., GET)
      @protected {
        not method POST
      }
      basicauth @protected {
        git $2a$14$VlDba5ipUmRYKPYmjPql8.pa8vO7cYsmUf26cXzTk.MbHoRA/ZKJy
      }

      # /backup → 127.0.0.1:3435
      @backup path /backup*
      reverse_proxy @backup 127.0.0.1:3435

      # everything else → 127.0.0.1:3322
      reverse_proxy * 127.0.0.1:3322

    '';
  };
}
