{
  description = "OCaml Packages";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

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
          let ocamlPackages = rec {
            callipyge = prev.callPackage ./pkgs/callipyge {
              inherit (prevOcamlPackages) buildDunePackage ocaml alcotest eqaf
                fmt
                ;
            };

            chacha = prev.callPackage ./pkgs/chacha {
              inherit (prevOcamlPackages) buildDunePackage ocaml alcotest
                cstruct mirage-crypto
                ;
            };

            noise = prev.callPackage ./pkgs/noise {
              inherit (prevOcamlPackages) buildDunePackage digestif hex lwt
                lwt_ppx nocrypto ounit ppxlib ppx_let ppx_deriving
                ppx_deriving_yojson
                ;
              inherit callipyge chacha;
            };

            rfc7748 = prev.callPackage ./pkgs/rfc7748 {
              inherit (prevOcamlPackages) buildDunePackage ounit zarith;
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
