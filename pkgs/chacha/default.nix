{ lib
, buildDunePackage
, src

, alcotest
, cstruct
, mirage-crypto
}:

buildDunePackage {
  pname = "chacha";
  version = "1.0.0";
  inherit src;

  useDune2 = true;
  doCheck = true;

  buildInputs = [ alcotest cstruct mirage-crypto ];
}
