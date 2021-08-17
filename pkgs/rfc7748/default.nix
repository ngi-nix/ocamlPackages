{ lib
, buildDunePackage
, src

, hex
, ounit
, zarith
}:

buildDunePackage {
  pname = "rfc7748";
  version = "1.0";
  inherit src;

  useDune2 = true;
  doCheck = true;

  buildInputs = [ hex ounit zarith ];
}
