let fontconfig = {
  defaultFonts = {
    sansSerif = [
      "Adwaita Sans"
      "Noto Sans"
      "Noto Sans Bengali"
      "Noto Naskh Arabic"
    ];
  };
};
in {
  flake.modules.nixos.gnome = {
    fonts.fontconfig = fontconfig;
  };
  
  flake.modules.homeManager.gnome = {
    fonts.fontconfig = fontconfig;
  };
}
