{ self, ... }: {
  flake.modules.nixos.ahmd-lpl = { pkgs, ... }: {
    home-manager.users.root.imports = [ self.modules.homeManager.ahmd-lpl ];
    
    networking.hostName = "ahmd-lpl";
  };
}
