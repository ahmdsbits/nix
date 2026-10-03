{ inputs, ... }: {
  flake.modules.nixos.samba = { pkgs, ... }: {
    services.samba = {
      enable = true;
      securityType = "user";
      openFirewall = true;

      extraConfig = ''
        workgroup = WORKGROUP
        security = user
        # Restrict to modern SMB versions
        server min protocol = SMB2
        server max protocol = SMB3
        hosts allow = 192.168.1. 127.0.0.1 localhost
        hosts deny = 0.0.0.0/0
      '';
    };
    services.samba-wsdd = {
      enable = true;
      openFirewall = true;
    };
  };
}
