inputs: {
  "programs/p10k" = import ./programs/p10k inputs;
  "programs/discord" = import ./programs/discord inputs;
  "programs/bitwarden" = import ./programs/bitwarden inputs;
  "programs/kubernetes" = import ./programs/kubernetes inputs;
  "programs/spotify" = import ./programs/spotify inputs;
  "programs/waybar" = import ./programs/waybar inputs;

  "extraConfig/gnupg" = import ./extraConfig/gnupg inputs;
  "extraConfig/ssh" = import ./extraConfig/ssh inputs;
}