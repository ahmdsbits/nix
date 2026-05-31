{ self, ... }: {
  perSystem = { pkgs, ... }: {
    apps.deploy = {
      type = "app";
      program = let
        configs = builtins.concatStringsSep " " (builtins.attrNames self.homeConfigurations);
        script = pkgs.writeShellScriptBin "deploy" ''
          set -e
          
          TARGET_HOST="''${1:-$(hostname)}"
          
          echo "Deploying NixOS configuration $TARGET_HOST"
          sudo nixos-rebuild switch --flake ".#$TARGET_HOST"
          echo
          
          for CONFIG in ${configs}; do
            if [[ "$CONFIG" == *"@$TARGET_HOST" ]]; then
              TARGET_USERNAME="''${CONFIG%%@*}"
              echo -e "Deploying user $CONFIG"
              sudo -H -u "$TARGET_USERNAME" bash -c "home-manager switch --flake \".#$CONFIG\""
            fi
          done
        '';
      in "${script}/bin/deploy";
    };
  };
}
