_: {
  pkgs,
  lib,
  config,
  ...
} : let 
  cfg = config.programs.qgis;
  enpt-enmapboxapp = pkgs.callPackage ./packages/enpt-enmapboxapp.nix {
    buildPythonPackage = pkgs.python311Packages.buildPythonPackage;
    setuptools =  pkgs.python311Packages.setuptools;
    psutil = pkgs.python311Packages.psutil;
  };
  typeguard = pkgs.callPackage ./packages/typeguard.nix {
    buildPythonPackage = pkgs.python311Packages.buildPythonPackage;
    setuptools =  pkgs.python311Packages.setuptools;
    setuptools-scm = pkgs.python311Packages.setuptools-scm;
  };
in {
  _file = ./default.nix;

  options.programs.qgis = {
    enable = lib.mkEnableOption "p10k";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
       (qgis-ltr.override {
          extraPythonPackages = (ps: [
            # Required by EnMAP-Box Core
            typeguard
            ps.astropy
            ps.xgboost
            ps.lightgbm
            ps.catboost

            # required by parts of EnMAP-Box Applications
            #ps.numba
            ps.sympy
            ps.netcdf4
            enpt-enmapboxapp
            ps.scikit-learn
            ps.pyopengl

            ps.scipy

            ps.pip

            ps.pyqt5
          ]);
        })
    ];
  };
}