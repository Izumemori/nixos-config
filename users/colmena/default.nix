{
  pkgs,
  inputs,
  config,
  lib,
  ...
} : {
  security.sudo.extraRules = [
    {
      users = [ "colmena" ];
      commands = [
        {
          command = "ALL";
          options = [ "SETENV" "NOPASSWD" ];
        }
      ];
    }
  ];

  users.users.colmena = {
    useDefaultShell = true;
  };
}