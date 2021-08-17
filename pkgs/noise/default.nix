{ lib
, buildDunePackage
, src

, benchmark
, callipyge
, chacha
, cstruct
, digestif
, eqaf
, fmt
, hex
, lwt
, lwt_ppx
, nocrypto
, ounit
, ppx_let
, ppx_deriving_yojson
, rfc7748
, tweetnacl
, yojson
}:

buildDunePackage {
  pname = "noise";
  version = "0.2.0";
  inherit src;

  useDune2 = true;
  doCheck = true;

  buildInputs = [
    benchmark
    callipyge
    chacha
    cstruct
    digestif
    eqaf
    fmt
    hex
    lwt
    lwt_ppx
    nocrypto
    ounit
    ppx_let
    ppx_deriving_yojson
    rfc7748
    tweetnacl
    yojson
  ];
}
