{ ... }: {
  flake.modules.homeManager.beets = { config, pkgs, ... }: {
    programs.beets = {
      enable = true;
      package = (pkgs.symlinkJoin {
        name = "beets-wrapped";
        paths = [
          (pkgs.python3.pkgs.beets.override {
            pluginOverrides = {
              musicbrainz.enable = true;
              chroma.enable = true;
              deezer.enable = true;
              fromfilename.enable = true;
              fetchart.enable = true;
              embedart.enable = true;
              lyrics.enable = true;
              lastgenre.enable = true;
              replaygain.enable = true;
              scrub.enable = true;
              ftintitle.enable = true;
            };
          })
        ];
        nativeBuildInputs = [ pkgs.makeWrapper ];
        postBuild = ''
          wrapProgram $out/bin/beet \
            --prefix PYTHONPATH : "${pkgs.python3.withPackages (ps: [ ps.pygobject3 ps.gst-python ])}/${pkgs.python3.sitePackages}"
        '';
      });
      settings = {
        directory = "${config.home.homeDirectory}/Music";
        library = "${config.home.homeDirectory}/.local/share/beets/library.db";
        pluginpath = [ "${./beetsplug}" ];

        paths = {
          default = "%first{$albumartists}/$album/$track - $title";
          singleton = "%first{$artists}/$title";
          comp = "Various Artists/%first{$albumartists}/$track - $title";
        };

        plugins = [
          "musicbrainz"
          "chroma"
          "deezer"
          "fromfilename"
          "fetchart"
          "embedart"
          "lyrics"
          "lastgenre"
          "replaygain"
          "scrub"
          "zero"
          "ftintitle"
          "info"
          # "splitartists"
        ];

        embedart = {
          remove_art_file = true;
          ifempty = true;
        };

        lastgenre = {
          cleanup_existing = true;
          force = true;
          source = "track";
          count = 3;
        };

        replaygain = {
          backend = "ffmpeg";
          targetlevel = 93;
          r128_targetlevel = 93;
          overwrite = true;
        };

        zero = {
          update_database = true;
          keep_fields = [
            "title"
            "artist"
            "artists"
            "artist_sort"
            "album"
            "albumartist"
            "albumartists"
            "albumartist_sort"
            "track"
            "tracktotal"
            "disc"
            "disctotal"
            "year"
            "month"
            "day"
            "original_year"
            "original_month"
            "original_day"
            "genres"
            "lyrics"
            "images"
            "rg_track_gain"
            "rg_track_peak"
            "rg_album_gain"
            "rg_album_peak"
            "r128_track_gain"
            "r128_album_gain"
          ];
        };
      };
    };

    home.packages = with pkgs; [
      ffmpeg
      chromaprint
    ];
  };
}
