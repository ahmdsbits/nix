{
  flake.modules.nixos.hsrv = {
      services.scx = {
        enable = true;
        scheduler = "scx_bpfland";
        extraArgs = [ "-s" "20000" "-S" ];
      };
  };
}
