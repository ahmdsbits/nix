{
  flake.modules.nixos.printing = { pkgs, ... }: {
    services.printing.enable = true;
    services.printing.drivers = with pkgs; [
      hplip
      foo2zjs
    ];
  };
}
