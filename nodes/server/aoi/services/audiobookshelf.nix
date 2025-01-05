{customLib, ...}: let lib = customLib; in {
  services.audiobookshelf = {
    enable = true;

    host = "0.0.0.0";
    port = 10245;

    nodeUser = lib.users.sam;
  };
}