{ self, inputs, ... }: {
  flake.nixosConfigurations.hsrv = inputs.nixpkgs.lib.nixosSystem {
    modules = with self.modules.nixos; [
      hsrv
      server
      ahmds
    ];
  };
  
  flake.homeConfigurations."ahmds@hsrv" = inputs.home-manager.lib.homeManagerConfiguration {
    pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
    modules = with self.modules.homeManager; [
      hsrv
      server
      ahmds
      beets
    ];
  };
}
