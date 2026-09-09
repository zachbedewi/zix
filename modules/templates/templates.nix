# nix flake init -t .#cpp
{ zix-lib, ... }: {
  flake.templates = zix-lib.mkTemplate "cpp" {
    description = "Standalone C++ project: CMake + CPM.cmake for dependencies, with a Nix flake for treefmt/git-hooks/devShell tooling.";
    path = ./_cpp;
  };
}
