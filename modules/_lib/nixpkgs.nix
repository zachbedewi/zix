overlays: {
  config.allowUnfree = true;

  overlays = with overlays; [
    stable
    unstable

    nur
  ];
}
