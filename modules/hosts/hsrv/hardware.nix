{ self, ... }: {
  flake.modules.nixos.hsrv = { pkgs, lib, config, ... }: {
    nixpkgs.hostPlatform = "x86_64-linux";

    hardware.enableRedistributableFirmware = true;
    hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    powerManagement.cpuFreqGovernor = lib.mkDefault "performance";
      
    services.fstrim.enable = true;
    hardware.bluetooth.enable = true;

    boot.kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-latest-lto;

    boot.initrd.availableKernelModules = [ "ehci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" ];
    boot.initrd.kernelModules = [  ];
    boot.kernelModules = [ "kvm-intel" ];
    boot.extraModulePackages = [ ];
    boot.supportedFilesystems = [ "ntfs" ];

    boot.kernelParams = [
      "zswap.enabled=1"
      "zswap.shrinker_enabled=1"
      "zswap.compressor=zstd"
      "zswap.max_pool_percent=70"
      "zswap.zpool=zsmalloc"
      "transparent_hugepage=madvise"
    ];

    boot.loader.efi.canTouchEfiVariables = true;
    boot.loader.limine = {
      enable = true;
      efiSupport = true;
      maxGenerations = 10;
      extraConfig = ''
        timeout: 1
      '';
      style = {
        wallpapers = [];
        backdrop = "000000";
        graphicalTerminal.background = "000000";
      };
    };

    zramSwap.enable = false;

    boot.kernel.sysctl = {
      "vm.swappiness" = 180;
      "vm.watermark_boost_factor" = 0;
      "vm.watermark_scale_factor" = 125;
      "vm.page-cluster" = 0;
      "vm.dirty_bytes" = 268435456;
      "vm.dirty_background_bytes" = 134217728;
      "vm.max_map_count" = 2147483642;
    };

    boot.tmp.cleanOnBoot = true;

    fileSystems = {
      "/" = {
        device = "/dev/disk/by-label/NixOS";
        fsType = "btrfs";
        options = [
          "subvol=.@root"
          "compress=zstd"
          "noatime"
          "ro"
        ];
      };

      "/tmp" = {
        device = "/dev/disk/by-label/NixOS";
        fsType = "btrfs";
        options = [
          "subvol=.@tmp"
          "compress=zstd"
          "noatime"
        ];
      };

      "/etc" = {
        device = "/dev/disk/by-label/NixOS";
        fsType = "btrfs";
        options = [
          "subvol=@etc"
          "compress=zstd"
          "noatime"
        ];
      };

      "/var" = {
        device = "/dev/disk/by-label/NixOS";
        fsType = "btrfs";
        options = [
          "subvol=@var"
          "compress=zstd"
          "noatime"
        ];
      };

      "/home" = {
        device = "/dev/disk/by-label/NixOS";
        fsType = "btrfs";
        options = [
          "subvol=@home"
          "compress=zstd"
          "noatime"
        ];
      };

      "/nix" = {
        device = "/dev/disk/by-label/NixOS";
        fsType = "btrfs";
        options = [
          "subvol=@nix"
          "compress=zstd"
          "noatime"
        ];
      };

      "/boot" = {
        device = "/dev/disk/by-label/EFI";
        fsType = "vfat";
      };
    };

    swapDevices = [ { label = "Swap"; discardPolicy = "both"; } ];
  };
}
