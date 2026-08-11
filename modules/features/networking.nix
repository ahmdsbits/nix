{
  flake.modules.nixos.networking = { pkgs, ... }: {  
    networking.networkmanager.enable = true;
    systemd.network.enable = false;
    
    networking.firewall = let
      allowed-range = { from = 1025; to = 65535; };
    in {
      allowedTCPPortRanges = [ allowed-range ];
      allowedUDPPortRanges = [ allowed-range ];
    };
    
    environment.systemPackages = with pkgs; [
      wget
      openssl
      netcat-gnu
      inetutils
    ];

    programs.openvpn3.enable = true;
    networking.wireguard.enable = true;
    networking.wireguard.useNetworkd = false;
  };
}
