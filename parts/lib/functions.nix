{
  inputs,
  lib,
  ...
} : let
usersToNameList = users: lib.mapAttrsToList (n: v: n) users;
in {
  inherit usersToNameList;
}