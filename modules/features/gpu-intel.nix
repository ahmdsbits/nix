{
  flake.modules.nixos.gpu-intel = { pkgs, ... }: {
    hardware.graphics.enable = true;
    hardware.graphics.enable32Bit = true;
    
    hardware.graphics = {
      extraPackages = with pkgs; [
        intel-media-driver
        libvdpau-va-gl
      ];
      extraPackages32 = with pkgs.pkgsi686Linux; [ intel-media-driver ];
    };
    environment.variables = {
      LIBVA_DRIVER_NAME = "iHD";
    };
  };
}
