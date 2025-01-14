{
  lib,
  pkgs,
  osConfig,
  ...
}: { 
  programs = {
    git = {
      enable = true;
      userEmail = "sam@rohli.ng";
      userName = "Sam Rohling";
      extraConfig = {
        user.signingkey = "0x8915fc124cf78a58";
        safe.directory = "*";
      };
    };

    gpg = let 
      gpgKey = pkgs.fetchurl {
        url = "https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x8915fc124cf78a58";
        hash = "sha256-JsBLOkmmgvw1Ya3QfPQL7/VriH9sYGT5/uMQaKwJh9w=";
      };
    in {
      enable = true;
      publicKeys = [
        {
          source = gpgKey.outPath;
          trust = 5;
        }
      ];
    };
  };
}