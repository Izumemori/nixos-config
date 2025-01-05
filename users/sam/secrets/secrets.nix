{ inputs, config, pkgs, lib, ... }: {
  sops.secrets."sam/hashedPassword" = {
    sopsFile = ./secrets.yaml;
    format = "yaml";
    neededForUsers = true;
  };
}