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

storage_vol = {
  pool = storage_pool;
  volume = storage_name;
};

q35 = moduleConfig.nixvirt.lib.domain.templates.q35 {
  inherit name uuid memory virtio_video storage_vol;

};

uefi = moduleConfig.nixvirt.lib.domain.templates.windows {
  # q35
  inherit name uuid memory virtio_video storage_vol;

  # uefi
  inherit virtio_net virtio_drive;

  nvram_path = moduleConfig.config.nvramPath + name + "_VARS.fd";
};
in
q35 //
{
  os = uefi.os;
  devices = uefi.devices;
}