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
    hashedPassword = config.sops.secrets."sam/hashedPassword".path;
  };
}