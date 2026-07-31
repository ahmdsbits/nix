{ self, inputs, ... }: {
  flake.nixosConfigurations.hsrv = inputs.nixpkgs.lib.nixosSystem {
    modules = with self.modules.nixos; [
      hsrv
      server
      
      # Users
      ahmds
    ];
  };
  
  flake.homeConfigurations."ahmds@hsrv" = inputs.home-manager.lib.homeManagerConfiguration {
    pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
    modules = with self.modules.homeManager; [
      ahmds
      server
      hsrv
    ];
  };
}
