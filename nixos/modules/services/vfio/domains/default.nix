moduleConfig: 
[
  {
    definition = ./xml/win11-6c-24GiB.xml;
    active = false;
  }
  {
    definition = ./xml/win11-4c-16GiB.xml;
    active = false;
  }
  {
    definition = moduleConfig.nixvirt.lib.domain.writeXML(import ./idle.nix moduleConfig);
    active = true;
  }
  {
    definition = moduleConfig.nixvirt.lib.domain.writeXML(import ./arch.nix moduleConfig);
    active = false;
  }
]