{ self, lib, ... }: {
  flake.modules.nixos.gnome = { pkgs, ... }: {
    services.pulseaudio.enable = false;
    services.pipewire.audio.enable = true;
    services.pipewire.alsa.enable = true;
    services.pipewire.pulse.enable = true;
    services.pipewire.jack.enable = true;
    
    services.xserver.enable = true;
    services.xserver.xkb.layout = "us";
    
    services.displayManager.gdm.enable = true;
    services.desktopManager.gnome.enable = true;
    programs.xwayland.enable = true;
    
    boot.plymouth.enable = true;
    
    # Fixes crash to GDM (maybe)
    systemd.services."getty@tty1".enable = false;
    systemd.services."autovt@tty1".enable = false;
    
    environment.systemPackages = with pkgs; [
      ghostty
      nautilus-python
      sushi
      resources
      papers
      gapless
      gnome-sound-recorder
      cine
      fragments
      eyedropper
      xclip
      gnome-tweaks
      adwaita-icon-theme-legacy
      adwaita-icon-theme
      adw-gtk3
    ];
    
    environment.gnome.excludePackages = with pkgs; [
      epiphany
      geary
      gnome-maps
      gnome-music
      decibels
      showtime
      evince
      gnome-system-monitor
      gnome-console
    ];
    
    # Allow GSConnect/KDEConnect to work
    networking.firewall = rec {
      allowedTCPPortRanges = [ { from = 1714; to = 1764; } ];
      allowedUDPPortRanges = allowedTCPPortRanges;
    };
    
    systemd.tmpfiles.rules = [
      "L+ /etc/xdg/monitors.xml        - - - - ${./monitors.xml}"
    ];
    
    imports = with self.modules.nixos; [
      # tweaks-gstreamer
    ];
  };
  
  flake.modules.homeManager.gnome = { options, pkgs, ... }: {
    services.flatpak = lib.optionalAttrs (options ? services.flatpak.packages) {
      packages = [
        "org.gtk.Gtk3theme.adw-gtk3"
        "org.gtk.Gtk3theme.adw-gtk3-dark"
        "com.github.tchx84.Flatseal"
      ];
      overrides = {
        global = {
          Context.filesystems = [
            "xdg-config/fontconfig:rw"
            "/run/current-system/sw/share/X11/fonts:ro"
            "/nix/store:ro"
            "xdg-data/fonts:rw"
          ];
          Environment = {
            ELECTRON_OZONE_PLATFORM_HINT = "auto";
          };
        };
      };
    };
    programs.gnome-shell = {
      enable = true;
      extensions = with pkgs.gnomeExtensions; [
        { package = appindicator; }
        { package = caffeine; }
        { package = copyous; }
        { package = gsconnect; }
      ];
    };
  };
}
