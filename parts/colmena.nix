{self, inputs, ...} : {
  flake.colmena = {
      meta = {
        description = "my personal machines";
        # This can be overriden by node nixpkgs
        nixpkgs = import inputs.nixpkgs { system = "x86_64-linux"; };
        nodeNixpkgs = builtins.mapAttrs (name: value: value.pkgs) self.nixosConfigurations;
        nodeSpecialArgs = builtins.mapAttrs (name: value: value._module.specialArgs) self.nixosConfigurations;
      };
    } // builtins.mapAttrs (name: value: { 
        nixpkgs.system = value.config.nixpkgs.system;
        imports = value._module.args.modules; 
        deployment = let
          nodeConfig = value._module.specialArgs.nodeConfig;
          in {
          targetUser = "colmena";
          targetHost = nodeConfig.IP or (nodeConfig.hostname + "." + nodeConfig.domain);
        };
      }) self.nixosConfigurations;
}