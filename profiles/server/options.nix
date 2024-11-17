{ inputs, components } : {
  components = with components; [
    server.ssh
  ];
}