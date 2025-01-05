
Users are defined in this directory. Users are identified by the folder name they're in, i.e. `users/sam/` would result in a user named "sam". A directory will automatically be detected as a user if certain conditions are met.

- An `options.nix` is present
- A `default.nix` is present
- All `*.nix` files except `options.nix` are regular files,  
  the `options.nix` file has a predefined format as seen [here](#default-optionsnix)

If you want to use home-manager on one of the nodes with this user a `<username>.nix` also needs to be present.  
Optionally if secrets are required for the user a subfolder called `secrets/` with a `secrets.nix` within it can be created in which the secrets are defined.  
As such a valid folder structure can look like:
```
sam/
    secrets/
        secrets.nix
        secrets.yaml
    options.nix
    default.nix
    sam.nix
```

> [!NOTE]
> All valid user directories will be available via `lib.users.<username>`

### Default `options.nix`
```nix
{
    # Whether or not the user is a system user
    # See: https://search.nixos.org/options?channel=24.11&show=users.users.%3Cname%3E.isSystemUser
    isSystemUser = false;

    # Should be set to true if the user is part of the nix trusted-users, as such having additional rights
    # when connecting to the nix daemon, useful for colmena deployments
    # See: https://search.nixos.org/options?channel=24.11&show=nix.settings.trusted-users
    trusted = false;

    # Whether or not the user is part of @wheel and is allowed to use sudo
    allowRoot = false;

    # The openssh keys of the user, mainly useful when ssh is enabled
    opensshKeys = [];

    home = {
        # Whether or not to create a home directory for the user
        # Also used for home-manager
        enable = false;

        # The path of the home directory
        path = "/home/${user}";
    };

    # When home-manager is enabled defines the home-manager modules that will be imported, ignored otherwise
    # "<username>.nix" will always be imported, extra components will be appended to that 
    components = [
        ./${user}.nix
    ];
}
```