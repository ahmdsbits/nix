{ inputs, self, ... }: {
  flake.modules.nixos.core = { pkgs, config, ... }: {
    system.stateVersion = "26.11";
    
    i18n.defaultLocale = "en_CA.UTF-8";
    time.timeZone = "Asia/Dhaka";
    
    environment.systemPackages = with pkgs; [
      usbutils
      exfatprogs
      pciutils
      file
      commons-compress
      unzip
      unrar
      p7zip
      lz4 
    ];
    
    programs.nix-ld.enable = true;
    programs.nix-ld.libraries = with pkgs; [
      stdenv.cc.cc.lib
      zlib
      openssl
      curl
      libuuid
    ];
    programs.command-not-found.enable = false;
    
    home-manager.useGlobalPkgs = true;
    home-manager.useUserPackages = true;
    home-manager.users.root.imports = [ self.modules.homeManager.core ];
    
    imports = with self.modules.nixos; [
      inputs.home-manager.nixosModules.home-manager
      # inputs.nix-index-database.nixosModules.default
    ];
  };
  
  flake.modules.homeManager.core = {
    home.stateVersion = "26.11";
    manual.manpages.enable = false;
  };
}
