This directory contains the user specific configuration.  
  
The generic configuration is contained in `default.nix`.  
Each user has a folder with their name, in that folder should be an `options.nix`, a `default.nix` and a `<name>.nix`.
The `options.nix` should contain meta configuration for the user, `default.nix` the nixos specific config for the user and `<name>.nix` the home-manager config.  

## Structure

### Default `options.nix`
```nix
{
    isManagementUser = false;
    trusted = false;
    home = {
        enabled = true;
        path = "/home/${user}";
    };
    components = [
        ./${user}.nix
    ];
}
```