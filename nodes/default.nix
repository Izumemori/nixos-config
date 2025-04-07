{
  withSystem,
  inputs,
  ...
}:{
  flake.nixosConfigurations = let
    inherit (inputs.self) lib;
  in with lib; with nodes.server; with nodes.desktop; {
    iodine = mkNode iodine { inherit withSystem; };
    work = mkNode work { inherit withSystem; };
    aoi = mkNode aoi { inherit withSystem; };
    db-1 = mkNode db { 
      inherit withSystem; 
      extraConfig = {
        hostname = "db-1";
      };
    };

    db-2 = mkNode db { 
      inherit withSystem; 
      extraConfig = {
        hostname = "db-2";
      };
    };

    db-3 = mkNode db { 
      inherit withSystem; 
      extraConfig = {
        hostname = "db-3";
      };
    };
  };
}