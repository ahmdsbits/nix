{ ... }: {
  flake.modules.homeManager.ahmds-devel = { pkgs, ... }: {
    home.packages = with pkgs; [
      steelix
      lua-language-server
      stylua
      nixd
      gcc
      clang-tools
      typescript-language-server
      superhtml
      vscode-langservers-extracted
      emmet-language-server
      prettier
      texliveMedium
      texlab
    ];
  };
}
