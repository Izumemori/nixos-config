moduleConfig: [
  {
    definition = moduleConfig.nixvirt.lib.volume.writeXML(import ./idle.nix moduleConfig);
  }
]