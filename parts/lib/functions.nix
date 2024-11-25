{
  inputs,
  lib,
  ...
} : let
  concatListToAttrs = list: (builtins.listToAttrs (map (value: {name = value.name; inherit value; }) list));
in {
  inherit concatListToAttrs;
}