inputs: {
  "programs/p10k" = import ./programs/p10k inputs;
  "programs/discord" = import ./programs/discord inputs;
  "programs/bitwarden" = import ./programs/bitwarden inputs;
  "programs/qgis" = import ./programs/qgis inputs;
  
  "extraConfig/gnupg" = import ./extraConfig/gnupg inputs;
  "extraConfig/ssh" = import ./extraConfig/ssh inputs;
}