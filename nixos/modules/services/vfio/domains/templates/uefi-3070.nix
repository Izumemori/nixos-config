moduleConfig: {
  name,
  uuid,
  memory ? { count = 4; unit = "GiB"; },
  storage_pool ? "default",
  storage_name ? (name + ".qcow2"),
  virtio_video ? true,
  virtio_net ? true,
  virtio_drive ? true,
  ...
}: 
let
base = import ./uefi.nix moduleConfig {
  inherit name uuid memory storage_pool storage_name virtio_video virtio_net virtio_drive;
};
in
base //
{
  devices = base.devices // 
  {
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