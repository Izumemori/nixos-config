{ inputs, components } : {
  components = with components; [
    desktop.printing
    desktop.home-manager
  ];
}