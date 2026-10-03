{ self, ... }: {
  flake.modules.nixos.hsrv = { config, pkgs, ... }: {
    networking.hostName = "hsrv";

    services.openssh = {
      enable = true;
      ports = [ 22 ];
      settings = {
        PasswordAuthentication = true;
        AllowUsers = null;
        UseDns = true;
        X11Forwarding = false;
        PermitRootLogin = "no";
      };
    };

    services.samba = {
      extraConfig = ''
        server string = ${config.networking.hostName}
        netbios name = ${config.networking.hostName}
      '';

      shares = {
        Data = {
          path = "/mnt/Data";
          browseable = "yes";
          "read only" = "no";
          "guest ok" = "no";
          "create mask" = "0664";
          "directory mask" = "0775";
          "force user" = "ahmds";
          "force group" = "users";
        };

        Home = {
          path = "/home/ahmds";
          browseable = "yes";
          "read only" = "no";
          "guest ok" = "no";
          "valid users" = "ahmds";
          "create mask" = "0600";
          "directory mask" = "0700";
        };
      };
    };

    modules = [ self.modules.nixos.samba ];
  };
}
