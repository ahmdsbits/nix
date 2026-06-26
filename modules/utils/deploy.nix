{ self, config, ... }: {
  perSystem = { pkgs, ... }: {
    apps.deploy = {
      type = "app";
      program = let
        substituters = builtins.concatStringsSep " " config.shared.substituters.trusted-substituters;
        public-keys = builtins.concatStringsSep " " config.shared.substituters.trusted-public-keys;
        configs = builtins.concatStringsSep " " (builtins.attrNames self.homeConfigurations);
        script = pkgs.writeShellScriptBin "deploy" ''
          set -e
          
          TARGET_HOST="''${1:-$(hostname)}"
          
          echo "Deploying NixOS configuration $TARGET_HOST"
          sudo nixos-rebuild switch --flake ".#$TARGET_HOST" \
            --option extra-substituters "${substituters}" \
            --option extra-trusted-public-keys "${public-keys}"
          echo
          
          for CONFIG in ${configs}; do
            if [[ "$CONFIG" == *"@$TARGET_HOST" ]]; then
              TARGET_USERNAME="''${CONFIG%%@*}"
              echo -e "Deploying user $CONFIG"
              sudo -H -u "$TARGET_USERNAME" bash -c "home-manager switch --flake \".#$CONFIG\" -b bak"
            fi
          done
        '';
      in "${script}/bin/deploy";
    };
  };
}
