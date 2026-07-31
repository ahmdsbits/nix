{ self, inputs, ... }: {
  flake.modules.nixos.ahmds = {
    users.users.ahmds = {
      isNormalUser = true;
      description = "Ahmed Shahir Samin";
      extraGroups = [
        "wheel"
        "networkmanager"
        "dialout"
      ];
      autoSubUidGidRange = true;
      linger = true;
      initialPassword = "ahmds";
    };
  };
  
  flake.modules.homeManager.ahmds = { pkgs, ... }: {
    home.username = "ahmds";
    home.homeDirectory = "/home/ahmds";
  };
}
