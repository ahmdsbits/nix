{ config, ... }: {
  perSystem = { pkgs, ... }: {
    apps.nixos-install = {
      type = "app";
      program = let
        substituters = builtins.concatStringsSep " " config.shared.substituters.trusted-substituters;
        public-keys = builtins.concatStringsSep " " config.shared.substituters.trusted-public-keys;
        script = pkgs.writeShellScriptBin "nixos-install" ''
          set -e

          sudo nixos-install \
            --option extra-substituters "${substituters}" \
            --option extra-trusted-public-keys "${public-keys}" \
            --keep-going \
            --no-root-password \
            --flake $1
        '';
      in "${script}/bin/nixos-install";
    };
  };
}
