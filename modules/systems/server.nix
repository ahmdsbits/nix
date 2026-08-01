{ self, lib, ... }: {
  flake.modules.nixos.server = {
    imports = with self.modules.nixos; [
      core
      cli
      networking
    ];
  };
  
  flake.modules.homeManager.server = {
    programs.starship.enable = lib.mkForce false;
    imports = with self.modules.homeManager; [
      core
      cli
    ];
  };
}
