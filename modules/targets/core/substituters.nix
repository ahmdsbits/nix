{ config, lib, ... }: {
  options.shared.substituters = lib.mkOption {
    type = lib.types.attrsOf (lib.types.listOf lib.types.str);
    default = {};
    description = "List of nix substituters";
  };
  config.shared.substituters = {
    trusted-substituters = [
      "https://nix-community.cachix.org"
      "https://attic.xuyh0120.win/lantian"
    ];
    trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc="
    ];
  };
}
