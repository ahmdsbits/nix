{ self, ... }: {
  flake.modules.nixos.server = {
    imports = with self.modules.nixos; [
      core
      cli
      networking
    ];
  };
  
  flake.modules.homeManager.server = {
    programs.starship.enable = false;
    imports = with self.modules.homeManager; [
      core
      cli
    ];
  };
}
