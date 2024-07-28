moduleConfig: 
[
  {
    definition = moduleConfig.nixvirt.lib.pool.writeXML (import ./local.nix moduleConfig);
    active = true;
    volumes = import ./volumes moduleConfig;
  }
  {
    definition = moduleConfig.nixvirt.lib.pool.writeXML (import ./isos.nix moduleConfig);
    active = true;
  }
]