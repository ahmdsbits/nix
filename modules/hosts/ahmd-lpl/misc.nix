{
  flake.modules.nixos.ahmd-lpl = {
      users.groups.usb = {
        name = "usb";
      };
      services.udev.extraRules = ''
        SUBSYSTEM=="usb", MODE="0660", GROUP="usb", TAG+="uaccess"
        KERNEL=="hidraw*", SUBSYSTEM=="hidraw", MODE="0660", GROUP="usb", TAG+="uaccess", TAG+="udev-acl"
      '';
      
      services.scx = {
        enable = true;
        scheduler = "scx_lavd";
        extraArgs = [ "--performance" ];
      };
  };
}
