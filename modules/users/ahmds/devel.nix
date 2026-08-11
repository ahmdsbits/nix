{ ... }: {
  flake.modules.homeManager.ahmds-devel = { pkgs, ... }: {
    home.packages = with pkgs; [
      # Code stuff
      gcc
      nodejs
      python3

      # Devtools
      steelix
      lua-language-server
      stylua
      nixd
      clang-tools
      typescript-language-server
      superhtml
      vscode-langservers-extracted
      emmet-language-server
      prettier

      # AI
      antigravity-cli

      # Typesetting tools
      pandoc
      (texliveMedium.withPackages (ps: with ps; [
        upquote
        fvextra
      ]))
      texlab
      typst
      tinymist
    ];
  };
}
