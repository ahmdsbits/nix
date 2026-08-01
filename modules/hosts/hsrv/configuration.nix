{ self, ... }: {
  flake.modules.nixos.hsrv = { pkgs, ... }: {
    networking.hostName = "hsrv";

    fonts.packages = with pkgs; [
      nerd-fonts.iosevka
    ];
    services.kmscon = {
      enable = true;
      config = {
        hwaccel = true;
        font-name = "Iosevka Nerd Font";
        font-size = 14;
      };
      extraOptions = "--term xterm-256color";
    };

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
  };
}
