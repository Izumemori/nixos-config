moduleConfig:
let

base = import ./templates/uefi.nix moduleConfig {
  name = "arch";
  uuid = "bc217ed3-8126-4f4d-bffe-b2e8439435f9";
  memory = { count = 8; unit = "GiB"; };
  storage_vol = { pool = "default"; volume = "arch.qcow2"; };
};

in
base // 
{
  vcpu.count = 8;
}