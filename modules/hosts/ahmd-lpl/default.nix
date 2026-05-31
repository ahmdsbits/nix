{ self, inputs, ... }: {
  flake.nixosConfigurations.ahmd-lpl = inputs.nixpkgs.lib.nixosSystem {
    modules = with self.modules.nixos; [
      ahmd-lpl
      laptop
      gnome
      
      # Users
      ahmds
    ];
  };
  
  flake.homeConfigurations."ahmds@ahmd-lpl" = inputs.home-manager.lib.homeManagerConfiguration {
    pkgs = self.legacyPackages.x86_64-linux;
    modules = with self.modules.homeManager; [
      ahmds
      laptop
    ];
  };
}
