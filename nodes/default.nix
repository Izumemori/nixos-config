{
  withSystem,
  inputs,
  ...
}:{
  flake.nixosConfigurations = let
    inherit (inputs.self) lib;
  in with lib; with nodes.server; with nodes.desktop; {
    krypton = mkNode krypton { inherit withSystem; };
    iodine = mkNode iodine { inherit withSystem; };
    work-wsl = mkNode work-wsl { inherit withSystem; };
    aoi = mkNode aoi { inherit withSystem; };
  };
}