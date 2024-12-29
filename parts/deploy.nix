{
  inputs,
  lib,
  ...
} : {
  colmena-flake.deployment = {
    aoi = {
      targetHost = "aoi.dmz.local.izu.re";
      targetUser = "colmena";
    };
  };
}