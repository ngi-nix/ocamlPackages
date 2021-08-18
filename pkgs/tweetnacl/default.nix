{ lib
, buildDunePackage
, ocaml
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

  minimumOCamlVersion = "4.03";

  propagatedBuildInputs = [ bigstring hex ocplib-endian zarith ];

  # alcotest isn't available for OCaml < 4.05 due to fmt
  doCheck = lib.versionAtLeast ocaml.version "4.05";
  checkInputs = [ alcotest ];

  meta = {
    homepage = "https://github.com/vbmithr/ocaml-tweetnacl";
    description = "OCaml implementation of TweetNaCl";
    longDescription = ''
        TweetNaCl is the world's first auditable high-security cryptographic
      library. TweetNaCl fits into just 100 tweets while supporting all 25 of
      the C NaCl functions used by applications.
    '';
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ fufexan ];
  };
}
