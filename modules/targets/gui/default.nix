{
  flake.modules.nixos.gui = { pkgs, ... }: {
    programs.nix-ld.libraries = with pkgs; [
      libX11
      libXcursor
      libxcb
      libXi
      libXrender
      libXext
      libXfixes
      libXcomposite
      wayland
      libxkbcommon
      
      libGL
      vulkan-loader
      mesa
      
      fontconfig
      freetype
      pango
      cairo
      
      gtk3
      glib
      dbus
      atk
      expat
      
      alsa-lib
      libpulseaudio
      
      nss
      nspr
      cups.lib
    ];
  };
}
