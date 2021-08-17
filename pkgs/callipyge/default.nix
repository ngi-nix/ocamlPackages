{ lib
, buildDunePackage
, src

, alcotest
, eqaf
, fmt
}:

buildDunePackage {
  pname = "callipyge";
  version = "0.2";
  inherit src;

  useDune2 = true;
  doCheck = true;

  buildInputs = [ alcotest fmt eqaf ];
}
