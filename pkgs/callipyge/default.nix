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

  minimumOCamlVersion = "4.05";

  propagatedBuildInputs = [ fmt eqaf ];

  doCheck = true;
  checkInputs = [ alcotest ];

  meta = {
    homepage = "https://github.com/oklm-wsh/Callipyge";
    description = "Curve25519 in OCaml";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fufexan ];
  };
}
