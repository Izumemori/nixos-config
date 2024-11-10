{ inputs, ... }: let
  inherit (inputs.nixpkgs) lib;

  _lib = self: {
    extendedLib = {
      ###
      ##  Helpers for creating new objects in a strict format
      ###
      builders = import ./builders.nix { inherit inputs; lib = self; };
      modules = import ./modules.nix { inherit inputs; lib = self;};
    };

    inherit (self.extendedLib.builders) mkNode;
    inherit (self.extendedLib.modules) profiles components users nodes;
  };

  extensions = lib.composeManyExtensions [
    (_: _: inputs.nixpkgs.lib)
    (_: _: inputs.flake-parts.lib)
    (_: _: inputs.home-manager.lib)
  ];

  _extendedLib = (lib.makeExtensible _lib).extend extensions;
in {
  perSystem = {
    _module.args.lib = _extendedLib;
  };

  flake = {
    lib = _extendedLib;
  };
}