moduleConfig:
let

base = import ./templates/uefi-3070.nix moduleConfig {
  name = "idle";
  uuid = "88c074f9-c9fd-4a6d-9eb4-cd7c94318230";
  memory = { count = 512; unit = "MiB"; };
  virtio_video = false;
};

in
base // 
{
  vcpu.count = 1;
  devices = base.devices //
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
  };
}