{ customLib, ... }: let lib = customLib; in {
  sops.secrets = {
    "kubeconfig" = {
      format = "binary";
      sopsFile = ./kubeconfig;
      owner = lib.users.sam.username;
    };
  };
}