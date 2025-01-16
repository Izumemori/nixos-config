{
  inputs,
  lib,
  ...
} : let
  inherit (inputs) self nixpkgs;
  inherit (lib) mkDefault;
  inherit (lib.lists) singleton;

  mkNodeModules = {
      users ? [ lib.users.sam ],
      components ? [],
      extraModules ? []
    }: let
    in (map (val: val._path) users)
      ++ (map (val: val._path) components)
      ++ extraModules; 

  mkNode = node: {
    withSystem
  }: let 
    modules = mkNodeModules {
      inherit (node) users extraModules;
      components = node.components ++ node.profile.components;
    };

    pkgs = node.nixpkgs.legacyPackages.${node.system};
  in withSystem node.system ({
    inputs',
    self',
    config,
    ...
  }: #node.nixpkgs.lib.nixosSystem {
    import "${node.nixpkgs}/nixos/lib/eval-config.nix" {
    lib = lib;
    system = node.system;
    specialArgs = {
        inherit inputs self inputs' self';
        nodeConfig = node // { inherit lib; };
        customLib = lib;
        packages = pkgs;
    };

    modules = modules
      # SOPS
      ++ singleton ({
        imports = (if builtins.pathExists "${node._path}/secrets/secrets.nix" then [
          "${node._path}/secrets/secrets.nix"
        ] else []) ++ [ inputs.sops-nix.nixosModules.sops ]++ builtins.filter (v: builtins.pathExists v) (map (v: "${v._path}/secrets/secrets.nix") node.users);
        
        sops = if (builtins.substring 0 5 node.nixpkgs.lib.version) == "24.11" then {
          sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
        } else {
          gnupg.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
        };
      })
      ++ singleton (node._path)
      ++ singleton ({ config, pkgs, lib, ... }: {
        config.nixpkgs.flake.source = lib.mkForce "${node.nixpkgs.outPath}";
      })
      ++ singleton {
        networking.hostName = node.hostname;
        
        nixpkgs = {
          #buildPlatform = "x86_64-linux";
          hostPlatform = mkDefault node.system;
          flake.source = nixpkgs.outPath;
          config.allowUnfree = true;
        };
        nix.settings = {
          experimental-features = [ "nix-command" "flakes" ];
        };

        users.mutableUsers = false;

        # Default user config
        users.users = lib.attrsets.genAttrs (lib.map (v: v.username) node.users) (
          username: let
            user = lib.users.${username};
          in {
            group = "users";
            extraGroups = lib.mkIf user.allowRoot ["wheel"];
            isNormalUser = !user.isSystemUser;
            isSystemUser = user.isSystemUser;
            openssh.authorizedKeys.keys = user.opensshKeys;
            createHome = user.home.enable;
            home = lib.mkIf user.home.enable user.home.path;
          }
        );

        nix.settings.trusted-users = [ "@wheel" ] 
          ++ map (v: v.username) (builtins.filter (x: x.trusted) (map (v: v) node.users));

        time.timeZone = "Europe/Berlin";
        system.stateVersion = builtins.substring 0 5 lib.version;
      };
  });
in {
  inherit mkNode;
}