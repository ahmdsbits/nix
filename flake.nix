{
  description = "Ahmed's Nix catch-all config";
  
  inputs = {
    nixpkgs.url = "github:ahmdsbits/nixpkgs";

    flake-parts.url = "https://flakehub.com/f/hercules-ci/flake-parts/0.1";
    import-tree.url = "github:vic/import-tree";
    
    nix-cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel/release";
    lanzaboote.url = "https://flakehub.com/f/nix-community/lanzaboote/*";
    
    home-manager = {
      url = "https://flakehub.com/f/nix-community/home-manager/0.1";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-flatpak.url = "https://flakehub.com/f/gmodena/nix-flatpak/0";
  };
  
  outputs = inputs@{ flake-parts, import-tree, home-manager, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } ({ lib, ... }: {
      imports = [
        flake-parts.flakeModules.modules
        home-manager.flakeModules.home-manager
        (import-tree ./modules)
      ];
    });
}
