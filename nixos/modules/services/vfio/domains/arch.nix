moduleConfig:
let

base = import ./templates/uefi.nix moduleConfig {
  name = "arch";
  uuid = "bc217ed3-8126-4f4d-bffe-b2e8439435f8";
  memory = { count = 8; unit = "GiB"; };
};

in
base // 
{
  vcpu.count = 8;
  devices = base.devices // 
  {
    disk = base.devices.disk ++
    [
      {
        type = "block";
        device = "disk";
        driver = { name = "qemu"; type = "raw"; cache = "none"; io = "native"; discard = "unmap"; };
        source = { dev = "/dev/disk/by-id/ata-HGST_HUS724040ALA640_PN2334PCHH3HJB"; };
        target = { dev = "vdb"; bus = "virtio"; };
        address = { type = "pci"; domain = 0; bus = 8; slot = 0; function = 0; };
      }
      {
        type = "block";
        device = "disk";
        driver = { name = "qemu"; type = "raw"; cache = "none"; io = "native"; discard = "unmap"; };
        source = { dev = "/dev/disk/by-id/ata-ST31000524AS_9VPGJX3H"; };
        target = { dev = "vdc"; bus = "virtio"; };
        address = { type = "pci"; domain = 0; bus = 9; slot = 0; function = 0; };
      }
    ];
  };
}