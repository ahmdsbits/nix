{
  flake.modules.nixos.cli = { pkgs, ... }: {
    environment.shells = with pkgs; [ nushell ];
    users.defaultUserShell = pkgs.nushell;
    
    environment.variables = {};
    environment.sessionVariables = {};
  };
  
  flake.modules.homeManager.cli = { pkgs, ... }: {
    programs.nushell = {
      enable = true;
      settings = {
        show_banner = false;
      };
    };
    programs.zoxide = {
      enable = true;
      enableNushellIntegration = true;
    };
    programs.television = {
      enable = true;
      enableNushellIntegration = true;
    };
    programs.starship = {
      enable = true;
      enableNushellIntegration = true;
    };
  };
}
