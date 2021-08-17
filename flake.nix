{
  description = "OCaml Packages";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    callipyge = { url = "github:oklm-wsh/Callipyge"; flake = false; };
  };

  outputs = { self, nixpkgs, ... }@inputs:
    let
      supportedSystems = [
        "x86_64-linux"
        "aarch64-linux"
        "armv7l-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      supportedOcamlPackages = [
        "ocamlPackages_4_10"
        "ocamlPackages_4_11"
        "ocamlPackages_4_12"
      ];
      defaultOcamlPackages = "ocamlPackages_4_12";

      forAllOcamlPackages = nixpkgs.lib.genAttrs supportedOcamlPackages;
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;

      nixpkgsFor = forAllSystems (system:
        import nixpkgs {
          inherit system;
          overlays = [ self.overlay ];
        });
    in
    {
      overlay = final: prev:
        let mkOcamlPackages = prevOcamlPackages:
          with prevOcamlPackages;
          let ocamlPackages = {
            callipyge = prev.callPackage ./pkgs/callipyge {
              src = inputs.callipyge;
              inherit buildDunePackage eqaf fmt;
            };
          };
          in ocamlPackages;
        in
        let allOcamlPackages =
          forAllOcamlPackages (ocamlPackages:
            mkOcamlPackages final.ocaml-ng.${ocamlPackages});
        in
        allOcamlPackages // {
          ocamlPackages = allOcamlPackages.${defaultOcamlPackages};
        };

      ocamlPackages =
        let
          mkOcamlPackages = prev: self.overlay;
          allOcamlPackages = forAllOcamlPackages (ocamlPackages:
            mkOcamlPackages self.overlay.final.ocaml-ng.${ocamlPackages});
        in
        allOcamlPackages // {
          ocamlPackages = allOcamlPackages.${defaultOcamlPackages};
        };

      packages = forAllSystems (system:
        forAllOcamlPackages (ocamlPackages:
          nixpkgsFor.${system}.${ocamlPackages}
        )
      );
    };
}