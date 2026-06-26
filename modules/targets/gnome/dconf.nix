{
  flake.modules.nixos.gnome = { pkgs, ... }: {
    programs.dconf.enable = true;
    programs.dconf.profiles = {
      user = {
        enableUserDb = true;
        databases = [
          {
            keyfiles = [
              ./dconf
            ];
          }
        ];
      };
      gdm = {
        enableUserDb = true;
        databases = [
          {
            keyfiles = [
              ./dconf
            ];
          }
        ];
      };
    };
  };
}
