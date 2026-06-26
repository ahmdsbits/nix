{
  flake.modules.homeManager.ahmd-lpl = {
    services.easyeffects = {
      enable = true;
      preset = "AL";
      extraPresets = {
        AL = (builtins.fromJSON (builtins.readFile ./AL.json));
      };
    };
  };
}
