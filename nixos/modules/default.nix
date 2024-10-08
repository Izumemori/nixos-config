inputs: {
  "services/yubikey" = import ./services/yubikey inputs;
  "services/wireguard" = import ./services/wireguard inputs;
  "services/sops" = import ./services/sops inputs;
  "services/samba" = import ./services/samba inputs;
  "services/vfio" = import ./services/vfio inputs;

  "programs/steam" = import ./programs/steam inputs;
  "programs/ausweisapp2" = import ./programs/ausweisapp2 inputs;
  "programs/dotnet" = import ./programs/dotnet inputs;
}