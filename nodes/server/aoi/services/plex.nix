{customLib, pkgs, ...} : let lib = customLib; in {
  services.plex = {
    enable = true;
    nodeUser = lib.users.sam;

    extraPlugins = [
      (builtins.path {
        name = "Audnexus.bundle";
        path = pkgs.fetchFromGitHub {
          owner = "djdembeck";
          repo = "Audnexus.bundle";
          rev = "v1.3.2";
          sha256 = "sha256-BpwyedIjkXS+bHBsIeCpSoChyWCX5A38ywe71qo3tEI=";
        };
      })
    ];
  };
}