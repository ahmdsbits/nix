{ self, inputs, ... }: {
  flake.nixosConfigurations.ahmd-lpl = inputs.nixpkgs.lib.nixosSystem {
    modules = with self.modules.nixos; [
      ahmd-lpl
      laptop
      # secure-boot
      gnome
      
      # Users
      ahmds
    ];
  };
  
  flake.homeConfigurations."ahmds@ahmd-lpl" = inputs.home-manager.lib.homeManagerConfiguration {
    pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
    modules = with self.modules.homeManager; [
      ahmds
      ahmds-devel
      laptop
      ahmd-lpl
      gnome
    ];
  };
}
