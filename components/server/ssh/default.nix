{
  inputs',
  self',
  self,
  config,
  lib,
  nodeConfig,
  ...
}: {
  # Enable ssh access
  services.openssh = {
    enable = true;
    settings = {
      KbdInteractiveAuthentication = false;
      PasswordAuthentication = false;
    };
  };
}