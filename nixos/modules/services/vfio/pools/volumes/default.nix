moduleConfig: [
  {
    definition = moduleConfig.nixvirt.lib.volume.writeXML(import ./idle.nix moduleConfig);
  }
  {
    definition = moduleConfig.nixvirt.lib.volume.writeXML(import ./arch.nix moduleConfig);
  }  
]