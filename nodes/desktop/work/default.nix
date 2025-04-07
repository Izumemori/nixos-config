{ config, pkgs, customLib, ... }: let lib = customLib; in {
  environment.systemPackages = with pkgs; [
    wget
    git
    socat
  ];

  services.yubikey = {
    nodeUser = lib.users.sam;
  };

  nix.settings.auto-optimise-store = true;

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than +5d";
  };

  home-manager.users.${lib.users.sam.username} = {
    programs.zsh.sessionVariables = {
      KUBECONFIG = config.sops.secrets."kubeconfig".path;
    };
  };

  security.pki.certificates = [
    ''
    -----BEGIN CERTIFICATE-----
    MIIBnzCCAUagAwIBAgIRAIyNIL3RmO3lCs3tDmLmsrYwCgYIKoZIzj0EAwIwLjER
    MA8GA1UEChMIRXNzZXhQS0kxGTAXBgNVBAMTEEVzc2V4UEtJIFJvb3QgQ0EwHhcN
    MjUwMzA3MTM1NTQ5WhcNMzUwMzA1MTM1NTQ5WjAuMREwDwYDVQQKEwhFc3NleFBL
    STEZMBcGA1UEAxMQRXNzZXhQS0kgUm9vdCBDQTBZMBMGByqGSM49AgEGCCqGSM49
    AwEHA0IABEkqEzpvSbtpVaLwS0QtoZs6sjumZsdLsDPDT2GNgqVNC5f2LFfTn/yH
    rzb7vJnzQGpGmJByN8uXBGFJuKN0+jajRTBDMA4GA1UdDwEB/wQEAwIBBjASBgNV
    HRMBAf8ECDAGAQH/AgEBMB0GA1UdDgQWBBRypliYlD/K6V2DqV/o9lAAkQYVLjAK
    BggqhkjOPQQDAgNHADBEAiAFBgEuuMkNNIhakMgQH920Zo7EQy2OIEZR2RoyF+Lq
    TgIgHBv3NEaTs4zFQd+9mAGeS7erL7ftNq6mWSP6zbVZpjc=
    -----END CERTIFICATE-----
    ''
  ];
}