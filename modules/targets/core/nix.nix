{ inputs, lib, self, ... }: {
  flake.modules.nixos.core = { pkgs, config, ... }: {
    nixpkgs = {
      config.allowUnfree = true;
      overlays = [
        inputs.nix-cachyos-kernel.overlays.pinned
      ];
    };
    nix = let
      flakeInputs = (lib.filterAttrs (_: lib.isType "flake") inputs) // {
        nixpkgs = self;
      };
    in
    {
      package = pkgs.nixVersions.latest;
      settings = {
        experimental-features = "nix-command flakes";

        trusted-users = [ "ahmds" ];

        flake-registry = "";
        auto-optimise-store = true;

        # Workaround for https://github.com/NixOS/nix/issues/9574
        nix-path = config.nix.nixPath;
      };
      gc = {
        automatic = true;
        dates = "daily";
        options = "--delete-older-than 7d";
      };

      channel.enable = false;

      registry = lib.mkForce (lib.mapAttrs (_: flake: { inherit flake; }) flakeInputs);
      nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;
      # nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];
    };
  };
}
