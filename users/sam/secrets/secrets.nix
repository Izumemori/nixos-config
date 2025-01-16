{ inputs, config, pkgs, customLib, ... }: let lib = customLib; in {
  sops.secrets = {
    "sam/hashedPassword" = {
      sopsFile = ./secrets.yaml;
      format = "yaml";
      neededForUsers = true;
    };

    "sam/keys.txt" = {
      format = "binary";
      sopsFile = ./keys.txt;
      path = "/home/sam/.config/sops/keys.txt";
      owner = lib.users.sam.username;
      mode = "0600";
    };
  };
}