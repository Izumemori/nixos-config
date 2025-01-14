{ 
  inputs',
  self',
  self,
  config,
  lib,
  customLib,
  ...
} : {
  users.users.sam = {
    hashedPasswordFile = config.sops.secrets."sam/hashedPassword".path;
  };
}