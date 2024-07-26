moduleConfig: 
[
  {
    definition = moduleConfig.nixvirt.lib.pool.writeXML (import ./local.nix moduleConfig);
    active = true;
    volumes = import ./volumes moduleConfig;
  }
]