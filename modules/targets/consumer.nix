{ inputs, ... }: {
  flake.modules.nixos.consumer = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      
    ];
    
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
  
    programs.appimage = {
      enable = true;
      binfmt = true;
    };
    
    imports = [
      inputs.nix-flatpak.nixosModules.nix-flatpak
    ];
  };
  
  flake.modules.homeManager.consumer = {
    services.flatpak = {
      enable = true;
      update.onActivation = true;
      update.auto = {
        enable = true;
        onCalendar = "daily";
      };
      packages = [

      ];
    };
    imports = [
      inputs.nix-flatpak.homeManagerModules.nix-flatpak
    ];
  };
}
