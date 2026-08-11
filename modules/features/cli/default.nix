{ self, ... }: {
  flake.modules.nixos.cli = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      fd
      ripgrep
      fzf
      television
      zoxide
      tealdeer
      trashy
      yq
      screen
      zellij
    ];
    
    programs.nix-ld.libraries = with pkgs; [
      icu
      libunwind
      bzip2
      xz
      zstd
      lz4
      ncurses
      readline
      libxml2
      gmp
    ];
    
    home-manager.users.root.imports = [ self.modules.homeManager.cli ];
  };
}
