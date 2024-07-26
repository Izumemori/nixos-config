{  
  pkgs,
  lib,
  config,
  ...
} : let 
  flavor = "mocha";
  accent = "peach";
  enable = true;
in {
  config = {
    catppuccin = {
        inherit enable flavor accent;
    };
  };
}