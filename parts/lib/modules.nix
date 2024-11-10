{
  lib,
  ...
} : with lib.attrsets; let
  getDirs = dir: mapAttrsToList (name: value: name) 
        (filterAttrs (name: value: value == "directory") (builtins.readDir dir));

  dirHasDefaultNix = dir: builtins.hasAttr "default.nix" (
    filterAttrs (n: v: v == "regular") (builtins.readDir dir)
  );

  dirIsNodeDefinition = dir: (dirHasDefaultNix dir) && builtins.hasAttr "options.nix" (
    filterAttrs (n: v: v == "regular") (builtins.readDir dir)
  );

  recurseDirToAttrsetUntil = {dir, depth ? 255, until ? (dir: depth == 0), validIf ? dirHasDefaultNix}: (
                          if (until dir) then
                            {}
                          else
                            genAttrs (getDirs dir) (subdirName: recurseDirToAttrsetUntil { dir = (dir + "/${subdirName}"); depth = (depth - 1); inherit until validIf; } )
                        ) // (if (validIf dir) then 
                              {_name = lib.lists.last (lib.path.subpath.components (lib.path.splitRoot dir).subpath); _path = dir;}
                              else {});
in {
  components = recurseDirToAttrsetUntil { dir = ../../components; depth = 2; };
  profiles = recurseDirToAttrsetUntil { dir  = ../../profiles; depth = 2; };
  users = recurseDirToAttrsetUntil { dir = ../../users; depth = 1; };
  nodes = recurseDirToAttrsetUntil { dir = ../../nodes; until = dirIsNodeDefinition; validIf = dirIsNodeDefinition; };
}