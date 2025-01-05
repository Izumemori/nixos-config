{...}: {
  fileSystems = {
    # HDD storing a local copy of all my media, since the NAS is sometimes off
    "/mnt/media" = {
      device = "/dev/disk/by-uuid/28669a86-210f-47fe-85b8-d16f92f738ae";
      fsType = "btrfs";
      options = ["defaults" "rw"];
    };
  };
}