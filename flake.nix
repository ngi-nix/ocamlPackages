{
  description = "OCaml Packages";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    callipyge = { url = "github:oklm-wsh/Callipyge/v0.2"; flake = false; };
    chacha = { url = "github:abeaumont/ocaml-chacha/1.0.0"; flake = false; };
    rfc7748 = { url = "github:burgerdev/ocaml-rfc7748/v1.0"; flake = false; };
    tweetnacl = { url = "github:fufexan/ocaml-tweetnacl/dune"; flake = false; };
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
          let ocamlPackages = {
            callipyge = prev.callPackage ./pkgs/callipyge {
              src = inputs.callipyge;
              inherit (prevOcamlPackages) buildDunePackage alcotest eqaf fmt;
            };

            chacha = prev.callPackage ./pkgs/chacha {
              src = inputs.chacha;
              inherit (prevOcamlPackages) buildDunePackage alcotest cstruct mirage-crypto;
            };

            rfc7748 = prev.callPackage ./pkgs/rfc7748 {
              src = inputs.rfc7748;
              inherit (prevOcamlPackages) buildDunePackage hex ounit zarith;
            };

            tweetnacl = prev.callPackage ./pkgs/tweetnacl {
              src = inputs.tweetnacl;
              inherit (prevOcamlPackages) buildDunePackage alcotest bigstring hex ocplib-endian zarith;
            };
          };
          in ocamlPackages;
        in
        let allOcamlPackages =
          forAllOcamlPackages (ocamlPackages:
            mkOcamlPackages final.ocaml-ng.${ocamlPackages});
        in
        allOcamlPackages // {
          ocamlPackages = allOcamlPackages.${defaultOcamlPackages} // prev.ocamlPackages;
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
