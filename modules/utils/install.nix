{ self, config, ... }: {
  perSystem = { pkgs, ... }: {
    apps.nixos-install = {
      type = "app";
      program = let
        substituters = builtins.concatStringsSep " " config.shared.substituters.substituters;
        public-keys = builtins.concatStringsSep " " config.shared.substituters.trusted-public-keys;
        configs = builtins.concatStringsSep " " (builtins.attrNames self.homeConfigurations);
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
            
          for CONFIG in ${configs}; do
            if [[ "$CONFIG" == *"@$TARGET_HOSTNAME" ]]; then
              TARGET_USERNAME="''${CONFIG%%@*}"
              
              echo -e "Deploying user $CONFIG"
              nixos-enter --root /mnt -c \
                "NIX_CONFIG=\"sandbox = false\" nix-daemon --daemon & setpriv --reuid=ahmds --regid=users --init-groups env USER=ahmds HOME=/home/ahmds bash -c 'home-manager switch --flake \"${self}#$CONFIG\" -b bak'"
            fi
          done
        '';
      in "${script}/bin/nixos-install";
    };
  };
}
