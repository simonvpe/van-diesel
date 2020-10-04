{ project ? import ./nix {} }:

project.pkgs.mkShell {
  nativeBuildInputs = project.devTools;
}
