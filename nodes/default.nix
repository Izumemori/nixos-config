{
  withSystem,
  inputs,
  ...
}:{
  flake.nixosConfigurations = let
    inherit (inputs.self) lib;
  in with lib; {
    desktop = with nodes.desktop; {
      krypton = mkNode krypton { inherit withSystem; };
      iodine = mkNode iodine { inherit withSystem; };
    };

    server = with nodes.server; {
      aoi = mkNode aoi { inherit withSystem; };
    };
  };
}