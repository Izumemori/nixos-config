moduleConfig:
[
  {
    definition = moduleConfig.nixvirt.lib.network.writeXML (import ./bridge.nix moduleConfig);
    active = true;
  }
]