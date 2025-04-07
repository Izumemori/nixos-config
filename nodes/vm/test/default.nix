{ config, pkgs, customLib, ... }: let lib = customLib; in {
  services.yubikey.nodeUser = lib.users.sam;
  catppuccin.enable = true;
  
  # Host keys
  virtualisation = {
    memorySize = 4096;
    cores = 8;

    forwardPorts = [
      { from = "host"; host.port = 2222; guest.port = 22; }
    ];
    sharedDirectories = {
      hostkeys = {
        source = toString ../../../.;
        target = "/home/sam/nixos-config";
        securityModel = "none";
      };
    };
    qemu = {
      options = [
        "-device virtio-vga-gl"
        #"-vga virtio"
        "-display gtk,gl=on"
      ];
    };
  };

  # Root user without password and enabled SSH for playing around
  networking.firewall.enable = false;
  services.openssh.enable = lib.mkForce true;
  services.openssh.settings.PermitRootLogin =  lib.mkForce "yes";
  users.extraUsers.root.password = "";
  virtualisation.diskSize = lib.mkDefault (2 * 1024);
  #virtualisation.useBootLoader = true;

  environment.etc."ssh/ssh_host_ed25519_key" = {
    source = /home/sam/ssh.key;
  };
}