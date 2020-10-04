{ sources ? import ./sources.nix
}:

let
  pkgs = import sources.nixpkgs { };
  nixos = import "${sources.nixpkgs}/nixos" { configuration.imports = [./configuration.nix]; };

  # gitignore.nix
  gitignoreSource = (import sources."gitignore.nix" { inherit (pkgs) lib; }).gitignoreSource;

  src = gitignoreSource ./..;
in
{
  inherit pkgs src nixos;

  # provided by shell.nix
  devTools = [
    pkgs.niv
    pkgs.pre-commit
    pkgs.dosfstools
    pkgs.e2fsprogs
    pkgs.parted
  ];

  # to be built by github actions
  ci = {
    pre-commit-check = (import sources."pre-commit-hooks.nix").run {
      inherit src;
      hooks = {
        shellcheck.enable = true;
        nixpkgs-fmt.enable = true;
        nix-linter.enable = true;
      };
      # generated files
      excludes = [ "^nix/sources\.nix$" ];
    };
  };
}
