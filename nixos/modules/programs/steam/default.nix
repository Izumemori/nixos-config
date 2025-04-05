_: {
  pkgs,
  lib,
  config,
  ...
} : let 
  cfg = config.programs.steam;
  new-lact = pkgs.callPackage ./lact.nix { hwdata = pkgs.hwdata.overrideAttrs(old: new: rec {
    version = "0.393";

    src = pkgs.fetchFromGitHub {
      owner = "vcrhonek";
      repo = "hwdata";
      rev = "v${version}";
      hash = "sha256-RDp5NY9VYD0gylvzYpg9BytfRdQ6dim1jJtv32yeF3k=";
    };

    configureFlags = [];
  }); };
in {
  config = lib.mkIf cfg.enable {
    programs.steam = {
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
      localNetworkGameTransfers.openFirewall = true;

      extraCompatPackages = with pkgs; [ proton-ge-bin ];

      gamescopeSession.enable = true;
    };

    programs.gamemode.enable = true;

    programs.gamescope = {
      package = pkgs.gamescope-wsi;
      enable = true;
      env = {
        DXVK_HDR="1";
        ENABLE_HDR_WSI="1";
        ENABLE_GAMESCOPE_WSI="1";
        DISABLE_HDR_WSI="1";
      };
      args = [
        "-W 2560"
        "-H 1440"
        "-r 165"
        "--hdr-enabled"
        "--adaptive-sync"
        "--force-grab-cursor"
        "--hdr-debug-force-output"
        "--hdr-itm-enable"
        "-e"
      ];
    };

    users.users.sam.extraGroups = ["gamemode"];
    

    hardware.graphics = {
      enable = true;
      #extraPackages = [ pkgs.amdvlk ];
      #extraPackages32 = [ pkgs.driversi686Linux.amdvlk ];
      enable32Bit = true;
    };

    #environment.variables.AMD_VULKAN_ICD = "RADV";

    environment.systemPackages = with pkgs; [ 
      new-lact
      prismlauncher
      unigine-superposition
      ffmpeg-full
      kdePackages.kglobalaccel
      kdePackages.kglobalacceld
      (r2modman.overrideAttrs(old: new: rec {
        version = "3.1.57";
        src = fetchFromGitHub {
          owner = "ebkr";
          repo = "r2modmanPlus";
          rev = "v${version}";
          hash = "sha256-1b24tclqXGx85BGFYL9cbthLScVWau2OmRh9YElfCLs=";
        };

        offlineCache = fetchYarnDeps {
          yarnLock = "${src}/yarn.lock";
          hash = "sha256-3SMvUx+TwUmOur/50HDLWt0EayY5tst4YANWIlXdiPQ=";
        };
      }))      
    ];
    systemd.packages = [ new-lact ];
    systemd.services.lactd.wantedBy = ["multi-user.target"];


    hardware.pulseaudio.support32Bit = true;

    systemd.tmpfiles.rules = 
    let
      rocmEnv = pkgs.symlinkJoin {
        name = "rocm-combined";
        paths = with pkgs.rocmPackages; [
          rocblas
          hipblas
          clr
        ];
      };
    in [
      "L+    /opt/rocm   -    -    -     -    ${rocmEnv}"
    ];

    services.open-webui.enable = false;
    services.ollama = {
      enable = false;
      acceleration = "rocm";
      rocmOverrideGfx = "12.0.1";
    };


    nixpkgs.overlays = [
      (final: prev: {
        gamescope-wsi = prev.gamescope-wsi.override { enableExecutable = true; };
      })
    ];
  };
}