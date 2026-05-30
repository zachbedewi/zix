{
  ...
}:
{
  # Atomic secret provisioning for NixOS based on sops
  # https://github.com/mic92/sops-nix
  flake-file.inputs = {
    sops = {
      url = "github:mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
