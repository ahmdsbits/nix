{ self, config, ... }: {
  perSystem = { pkgs, ... }: {
    apps.nixos-install = {
      type = "app";
      program = let
        substituters = builtins.concatStringsSep " " config.shared.substituters.trusted-substituters;
        public-keys = builtins.concatStringsSep " " config.shared.substituters.trusted-public-keys;
        script = pkgs.writeShellScriptBin "nixos-install" ''
          set -e
          
          if [[ "$1" == "--flake" ]]; then
            if [[ -z "$2" ]]; then
              echo "Error: --flake requires an argument."
              exit 1
            fi
            TARGET_FLAKE="$2"
          else
            TARGET_HOSTNAME="$1"
            TARGET_FLAKE="${self}#$TARGET_HOSTNAME"
          fi

          sudo nixos-install \
            --option extra-substituters "${substituters}" \
            --option extra-trusted-public-keys "${public-keys}" \
            --keep-going \
            --no-root-password \
            --flake "$TARGET_FLAKE"
        '';
      in "${script}/bin/nixos-install";
    };
  };
}
