{customLib, ...}: let lib = customLib; in {
  services.navidrome = {
    enable = true;
    nodeUser = lib.users.sam;
    openFirewall = true;
    config = {
      host = "0.0.0.0";
      port = 10244;
      musicFolder = "/mnt/media/plex/Music";

      lastfm = {
        enable = true;
        apiKeyPlaceholder = "navidrome/lastfm/key";
        apiSecretPlaceholder = "navidrome/lastfm/secret";
      };

      spotify = {
        enable = true;
        apiKeyPlaceholder = "navidrome/spotify/id";
        apiSecretPlaceholder = "navidrome/spotify/secret";
      };
    };
  };
}