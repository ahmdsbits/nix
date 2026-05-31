{
  flake.modules.nixos.cli = { pkgs, ... }: {
    environment.shells = with pkgs; [ nushell ];
    users.defaultUserShell = pkgs.nushell;
    
    environment.variables = {};
    environment.sessionVariables = {};
  };
  
  flake.modules.homeManager.cli = { pkgs, ... }: {
    programs.zoxide = {
      enable = true;
      enableNushellIntegration = true;
    };
    programs.television = {
      enable = true;
      enableNushellIntegration = true;
    };
  };
}
