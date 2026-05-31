{ self, ... }: {
  flake.modules.nixos.ahmd-lpl = { pkgs, lib, config, ... }: {
    nixpkgs.hostPlatform = "x86_64-linux";
    hardware.enableRedistributableFirmware = true;
    hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    powerManagement.cpuFreqGovernor = lib.mkDefault "ondemand";

    hardware.graphics.enable32Bit = true;
    services.hardware.bolt.enable = true;
    hardware.bluetooth.enable = true;
    hardware.sensor.iio.enable = true;
    
    boot.kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-latest-lto-x86_64-v4;

    boot.initrd.availableKernelModules = [
      "xhci_pci"
      "thunderbolt"
      "nvme"
      "usb_storage"
      "usbhid"
      "sd_mod"
    ];
    boot.initrd.kernelModules = [ ];
    boot.kernelModules = [ "kvm-intel" ];
    boot.extraModulePackages = [ ];
    boot.supportedFilesystems = [ "ntfs" ];

    boot.kernelParams = [
      "quiet"
      "splash"
      "loglevel=3"
      "systemd.show_status=auto"
      "rd.udev.log_level=3"
      "zswap.enabled=1"
      "zswap.shrinker_enabled=1"
      "zswap.compressor=zstd"
      "zswap.max_pool_percent=60"
      "zswap.zpool=zsmalloc"
      "transparent_hugepage=madvise"
      # "i915.force_probe=!7dd5"
      # "xe.force_probe=7dd5"
    ];

    boot.initrd.systemd.enable = true;

    boot.loader.systemd-boot.enable = true;
    boot.loader.timeout = 0;
    boot.loader.systemd-boot.configurationLimit = 6;
    boot.loader.systemd-boot.consoleMode = "max";
    boot.loader.efi.canTouchEfiVariables = true;

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

    boot.initrd.systemd.extraBin = {
      mkdir = "${pkgs.coreutils}/bin/mkdir";
    };
    boot.initrd.systemd.services.clean = {
      description = "Clean up root and tmp";
      wantedBy = [ "initrd.target" ];
      before = [ "sysroot.mount" ];
      requires = [ "dev-disk-by\\x2dlabel-NixOS.device" ];
      after = [ "dev-disk-by\\x2dlabel-NixOS.device" ];
      unitConfig.DefaultDependencies = "no";
      serviceConfig.Type = "oneshot";
      script = ''
        /bin/mkdir -p /clean
        # Mount the top-level btrfs filesystem, not the individual subvolumes
        /bin/mount -t btrfs -o subvol=/ /dev/disk/by-label/NixOS /clean

        # Delete the old subvolumes
        # Note: If you have nested subvolumes inside root/tmp, you may need a loop to delete them first, 
        # or use `btrfs subvolume delete -c` depending on your btrfs-progs version.
        btrfs subvolume delete /clean/.@root
        btrfs subvolume delete /clean/.@tmp

        # Create fresh, empty subvolumes in their place
        btrfs subvolume create /clean/.@root
        btrfs subvolume create /clean/.@tmp

        /bin/umount /clean
        /bin/rm -rf /clean
      '';
    };

    fileSystems = {
      "/" = {
        device = "/dev/disk/by-label/NixOS";
        fsType = "btrfs";
        options = [
          "subvol=.@root"
          "noatime"
        ];
      };

      "/tmp" = {
        device = "/dev/disk/by-label/NixOS";
        fsType = "btrfs";
        options = [
          "subvol=.@tmp"
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

    swapDevices = [ { label = "Swap"; } ];
  
    imports = with self.modules.nixos; [
      gpu-intel
    ];
  };
}
