{
  flake.modules.nixos.cli = { pkgs, lib, ... }: {
    environment.shells = with pkgs; [ fish ];
    users.defaultUserShell = pkgs.fish;
    programs.fish.enable = true;

    environment.variables = {};
    environment.sessionVariables = {};

    environment.systemPackages = with pkgs; [
      (lib.hiPrio (writeShellScriptBin "xdg-open" ''
        exec ${xdg-utils}/bin/xdg-open "$@" > /dev/null 2>&1
      ''))
    ];
  };

  flake.modules.homeManager.cli = { ... }: {
    programs.fish = {
      enable = true;
      interactiveShellInit = ''
        set -U fish_greeting
        function postexec_test --on-event fish_postexec
          echo
        end
      '';
    };

    programs.zoxide = {
      enable = true;
      enableFishIntegration = true;
      options = [
        "--cmd cd"
      ];
    };

    programs.eza = {
      enable = true;
      enableFishIntegration = true;
      git = true;
    };
    home.shellAliases = {
      ls = "eza";
      l = "eza -lh";
      la = "eza -a";
      ll = "eza -lah --git --group-directories-first";
      lm = "eza -lah --git --sort=modified";
      lt = "eza --tree --level=2";
      lT = "eza --tree";
    };

    programs.television = {
      enable = true;
      enableFishIntegration = true;
    };

    programs.starship = {
      enable = true;
      enableFishIntegration = true;
      settings = {
        add_newline = false;
        nix_shell = {
          disabled = false;
        };
      };
    };

    programs.direnv = {
      enable = true;
      enableFishIntegration = true;
      nix-direnv.enable = true;
      silent = true;
    };
  };
}
