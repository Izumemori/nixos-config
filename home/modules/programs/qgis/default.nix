_: {
  pkgs,
  lib,
  config,
  ...
} : let 
  cfg = config.programs.qgis;
in {
  _file = ./default.nix;

  options.programs.qgis = {
    enable = lib.mkEnableOption "p10k";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
       (qgis-ltr.override {extraPythonPackages = (ps: with ps; [
          # Required by EnMAP-Box Core
          #typeguard
          astropy
          xgboost
          lightgbm
          catboost

          # required by parts of EnMAP-Box Applications
          #numba
          sympy
          #netCDF4
          #enpt-enmapboxapp
          scikit-learn
          #PyOpenGL

          scipy

          pip
        ]);})
    ];
  };
}