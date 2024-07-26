moduleConfig:
let

name = "Idle";
uuid = "88c074f9-c9fd-4a6d-9eb4-cd7c94318230";
memory = { count = 512; unit = "MiB"; };
nvram_path = moduleConfig.config.nvramPath + "/idle_VARS.fd";
storage_vol = { pool = "default"; volume = "idle.qcow2"; };
virtio_video = false;
virtio_net = true;
virtio_drive = true;

q35 = moduleConfig.nixvirt.lib.domain.templates.q35 {
  inherit name uuid memory storage_vol virtio_video;
};

uefi = moduleConfig.nixvirt.lib.domain.templates.windows {
  inherit name uuid memory nvram_path storage_vol virtio_net virtio_video virtio_drive;
};

in
q35 // 
{
  vcpu.count = 1;
  os = uefi.os;
  devices = uefi.devices //
  {
    video = {
      model = {
        type = "vga";
        vram = 16384;
        heads = 1;
        primary = true;
      };
      address = {
        type = "pci";
        domain = 0;
        bus = 0;
        slot = 1;
        function = 0;
      };
    };
    hostdev = [
      { # 3070
        mode = "subsystem";
        type = "pci";
        managed = true;
        source.address =
        {
          domain = 0;
          bus = 8;
          slot = 0;
          function = 0;
        };
        address = {
          type = "pci";
          domain = 0;
          bus = 5;
          slot = 0;
          function = 0;
        };
      }
      { # 3070 Audio
        mode = "subsystem";
        type = "pci";
        managed = true;
        source.address = {
          domain = 0;
          bus = 8;
          slot = 0;
          function = 1;
        };
        address = {
          type = "pci";
          domain = 0;
          bus = 6;
          slot = 0;
          function = 0;
        };
      }
    ];
  };
}