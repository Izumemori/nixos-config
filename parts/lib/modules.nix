{
  inputs,
  lib,
  ...
} : with lib; with attrsets; let
  getDirs = dir: mapAttrsToList (name: value: name) 
        (filterAttrs (name: value: value == "directory") (builtins.readDir dir));

  dirHasDefaultNix = dir: builtins.hasAttr "default.nix" (
    filterAttrs (n: v: v == "regular") (builtins.readDir dir)
  );
  dirHasOptionsNix = dir: builtins.hasAttr "options.nix" (
    filterAttrs (n: v: v == "regular") (builtins.readDir dir)
  );

  dirIsNodeDefinition = dir: (dirHasDefaultNix dir) && (dirHasOptionsNix dir);
  dirIsUserDefinition = dir: (dirHasDefaultNix dir) && (dirHasOptionsNix dir);

  recurseDirToAttrsetUntil = {dir, depth ? 255, until ? (dir: depth == 0), validIf ? dirHasDefaultNix}: (
                          if (until dir) then
                            {}
                          else
                            genAttrs (getDirs dir) (subdirName: recurseDirToAttrsetUntil { dir = (dir + "/${subdirName}"); depth = (depth - 1); inherit until validIf; } )
                        ) // (if (validIf dir) then 
                              {name = lib.lists.last (lib.path.subpath.components (lib.path.splitRoot dir).subpath); _path = dir;}
                              else {});

  configureUsers = users: components: mapAttrs(n: v: let 
    userOptions = import ("${v._path}/options.nix") { inherit inputs components; };
  in v //
  {
    config = {
      isManagementUser = userOptions.isManagementUser or false;
      trusted = userOptions.trusted or false;
      allowRoot = userOptions.allowRoot or false;
      opensshKeys = userOptions.opensshKeys or []; 
      home = {
        enabled = false;
        path = "/home/${v.name}";
      } // (userOptions.home or {});
      components = [
        "${v._path}/${v.name}.nix"
      ] ++ (userOptions.components or []);
    };
  }) users;

  configureProfiles = profiles: components: mapAttrsRecursiveCond
    (as: builtins.isAttrs as && !(as ? "_path"))
    (n: v: let
      profileOptions = import "${v._path}/options.nix" { inherit inputs components; };
    in v // {
      config = {
        components = profileOptions.components or [];
      };
    }) profiles;

  configureNodes = {
    nodes,
    components,
    profiles,
    users
  } : mapAttrsRecursiveCond
      (as: builtins.isAttrs as && !(as ? "_path"))
      (n: v: let
      nodeOptions = import ("${v._path}/options.nix") { inherit inputs components profiles users; };        
    in v // {
      config = {
        inherit (nodeOptions) hostname domain system profile users;
        components = nodeOptions.components or [];
        extraModules = nodeOptions.extraModules or [];
      };
    }
  ) nodes;

  _modules = {
    components = recurseDirToAttrsetUntil { dir = ../../components; depth = 2; };
    profiles = recurseDirToAttrsetUntil { dir  = ../../profiles; depth = 2; validIf = dirHasOptionsNix; };
    users = recurseDirToAttrsetUntil { dir = ../../users; depth = 1; validIf = dirIsUserDefinition; };
    nodes = recurseDirToAttrsetUntil { dir = ../../nodes; until = dirIsNodeDefinition; validIf = dirIsNodeDefinition; };
  };

  modules = rec {
    inherit (_modules) components;

    users = configureUsers _modules.users _modules.components; 
    profiles = configureProfiles _modules.profiles _modules.components;
    nodes = configureNodes { inherit (_modules) nodes components; inherit users profiles; };
  };
in {
  inherit (modules) users components profiles nodes;
}