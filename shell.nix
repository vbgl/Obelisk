{ pkgs ? import <nixpkgs> {}
}:

with pkgs;

mkShell {
  buildInputs = with ocamlPackages; [
    ocaml findlib dune_2
    merlin
    menhir
    re
  ];
}
