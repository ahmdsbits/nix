{ self, ... }: {
  flake.modules.nixos.printing = { pkgs, ... }: {
    services.printing.enable = true;
    services.printing.drivers = with pkgs; [
      hplip
      foo2zjs
    ];
    home-manager.users.root.imports = [ self.modules.homeManager.printing ];
  };
  flake.modules.homeManager.printing = {
    xdg = {
      enable = true;
      desktopEntries.cups = {
        name = "Manage Printing";
        noDisplay = true;
      };
    };
  };
}
