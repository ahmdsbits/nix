{
  flake.modules.nixos.hsrv = {
      services.scx = {
        enable = true;
        scheduler = "scx_lavd";
        extraArgs = [ "-s" "20000" "-S" ];
      };
  };
}
