{ inputs, ... }: {
  flake.modules.nixos.consumer = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [];
    programs.appimage = {
      enable = true;
      binfmt = true;
    };
    
    services.flatpak.enable = true;
    
    environment.etc."brave/policies/managed/debloat.json".text = ''
      {
        "BraveRewardsDisabled": true,
        "BraveWalletDisabled": true,
        "BraveVPNDisabled": 1,
        "BraveAIChatEnabled": false,
        "BraveTalkDisabled": true,
        "BraveNewsDisabled": true,
        "TorDisabled": true
      }
    '';
  };
  
  flake.modules.homeManager.consumer = { lib, ... }: {
    services.flatpak = {
      enable = true;
      update.onActivation = true;
      update.auto = {
        enable = true;
        onCalendar = "daily";
      };
      packages = [
        "com.brave.Browser"
        "org.libreoffice.LibreOffice"
        "org.gimp.GIMP"
        "org.inkscape.Inkscape"
        "md.obsidian.Obsidian"
      ];
    };
    
    home.activation.flatpak = lib.hm.dag.entryAfter ["writeBoundary"] ''
      watch systemctl --user status flatpak-managed-install.service 2>/dev/null || true
    '';
    
    imports = [
      inputs.nix-flatpak.homeManagerModules.nix-flatpak
    ];
  };
}
