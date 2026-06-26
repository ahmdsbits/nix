{ self, ... }: {
  flake.modules.nixos.laptop = {
    imports = with self.modules.nixos; [
      core
      cli
      gui
      networking
      printing
      consumer
    ];
  };
  
  flake.modules.homeManager.laptop = {
    imports = with self.modules.homeManager; [
      core
      cli
      gui
      consumer
    ];
  };
}
