{
  flake.modules.nixos.ahmd-lpl = {
    networking.hostName = "ahmd-lpl";
    services.cloudflare-warp.enable = true;
  };
}
