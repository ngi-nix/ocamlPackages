{ lib
, buildDunePackage
, src

, eqaf
, fmt
}:

buildDunePackage {
  pname = "callipyge";
  version = "0.2";
  inherit src;

  useDune2 = true;
  doCheck = true;

  nativeBuildInputs = [ fmt eqaf ];
}
