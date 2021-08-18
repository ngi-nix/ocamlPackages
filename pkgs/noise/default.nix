{ lib
, buildDunePackage
, src

, benchmark
, callipyge
, chacha
, digestif
, lwt
, lwt_ppx
, nocrypto
, ounit
, ppx_let
, ppx_deriving_yojson
, rfc7748
, tweetnacl
}:

buildDunePackage {
  pname = "noise";
  version = "0.2.0";

  inherit src;

  useDune2 = true;

  minimumOCamlVersion = "4.05";

  doCheck = true;
  checkInputs = [
    benchmark
    lwt_ppx
    ounit
    ppx_deriving_yojson
  ];

  propagatedBuildInputs = [
    callipyge
    chacha
    digestif
    lwt
    nocrypto
    ppx_let
    rfc7748
    tweetnacl
  ];

  meta = {
    homepage = "https://github.com/emillon/ocaml-noise";
    description = "OCaml implementation of the Noise Protocol Framework";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ fufexan ];
  };
}
