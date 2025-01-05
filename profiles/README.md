Profiles are sort of "bundles" that include multiple modules that are usually used together. For example the `server` profile will include the `server.ssh` module.

> [!NOTE]
> A `default.nix` with common configuration might be useful in the future!

The `options.nix` file is structured fairly simply and allows only one configuration option `components` which accepts a list of components.  
  
> [!NOTE]
> Profiles are available under `lib.profiles.<profile>`