{ lib
, buildDunePackage
, src

, alcotest
, bigstring
, hex
, ocplib-endian
, zarith
}:

buildDunePackage {
  pname = "tweetnacl";
  version = "unstable-2021-08-17";
  inherit src;

  useDune2 = true;
  doCheck = true;

  buildInputs = [ alcotest bigstring hex ocplib-endian zarith ];
}
