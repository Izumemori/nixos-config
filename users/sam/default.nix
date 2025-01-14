{ 
  config,
  pkgs,
  ...
} : {
  programs.zsh.enable = true;

  users.users.sam = {
    hashedPasswordFile = config.sops.secrets."sam/hashedPassword".path;
    shell = pkgs.zsh;
  };
}