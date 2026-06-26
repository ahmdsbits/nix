let fontconfig = {
  enable = true;
  defaultFonts = {
    serif = [
      "Libre Baskerville"
      "Noto Serif"
      "Noto Serif Bengali"
      "Amiri"
    ];
    monospace = [ "Iosevka Nerd Font" ];
  };
};
in {
  flake.modules.nixos.gui = { pkgs, ... }: {
    fonts.fontDir.enable = true;
    fonts.packages = with pkgs; [
      caladea
      noto-fonts
      noto-fonts-cjk-serif
      noto-fonts-cjk-sans
      noto-fonts-color-emoji
      amiri
      texlivePackages.librebaskerville
      texlivePackages.palatino
      eb-garamond
      inter
      nerd-fonts.iosevka
    ];

    fonts.fontconfig = fontconfig;
  };
  
  flake.modules.homeManager.gui = {
    fonts.fontconfig = fontconfig;
  };
}
