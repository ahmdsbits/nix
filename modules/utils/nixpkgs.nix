{ inputs, ... }: {
  systems = inputs.nixpkgs.lib.systems.flakeExposed; 

  perSystem = { system, ... }: 
  let
    pkgs = import inputs.nixpkgs {
      inherit system;
      config.allowUnfree = true;
      overlays = [
        inputs.nix-cachyos-kernel.overlays.pinned
      ];
    };
  in {
    legacyPackages = pkgs;
    _module.args.pkgs = pkgs;
  };
}
