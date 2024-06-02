_: {
  pkgs,
  lib,
  config,
  ...
} : let 
  cfg = config.programs.p10k;
  zshCfg = config.programs.zsh;
in {
  _file = ./default.nix;

  options.programs.p10k = {
    enable = lib.mkEnableOption "p10k";
  };

  config = lib.mkIf (cfg.enable && zshCfg.enable) {
    #programs.zsh.enable = true;
    programs.zsh.plugins = [
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
      {
        name = "powerlevel10k-config";
        src = ./p10k-config;
        file = "p10k.zsh";
      }
    ];
  };
}