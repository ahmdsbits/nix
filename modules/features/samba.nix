{ inputs, ... }: {
  flake.modules.nixos.samba = { pkgs, ... }: {
    services.samba = {
      enable = true;
      openFirewall = true;

      settings = {
        global = {
          workgroup = "WORKGROUP";
          security = "user";
          "server min protocol" = "SMB2";
          "server max protocol" = "SMB3";
          "hosts allow" = "192.168.0. 127.0.0.1 localhost";
          "hosts deny" = "0.0.0.0/0";
        };
      };
    };
    services.samba-wsdd = {
      enable = true;
      openFirewall = true;
    };
  };
}
