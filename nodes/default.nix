{
  withSystem,
  inputs,
  ...
}:{
  flake.nixosConfigurations = let
    inherit (inputs.self) lib;
  in with lib; with nodes.server; with nodes.desktop; {
    #krypton = mkNode krypton { inherit withSystem; };
    iodine = mkNode iodine { inherit withSystem; };
    work = mkNode work { inherit withSystem; };
    aoi = mkNode aoi { inherit withSystem; };

    test = mkNode nodes.vm.test { inherit withSystem; };
  };
}