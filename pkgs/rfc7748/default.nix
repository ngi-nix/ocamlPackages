{ lib
, buildDunePackage
, fetchFromGitHub

, ounit
, zarith
}:

buildDunePackage rec {
  pname = "rfc7748";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "burgerdev";
    repo = "ocaml-rfc7748";
    rev = "v${version}";
    sha256 = "sha256-mgZooyfxrKBVQFn01B8PULmFUW9Zq5HJfgHCSJSkJo4=";
  };

  useDune2 = true;

  minimumOCamlVersion = "4.03";

  propagatedBuildInputs = [ zarith ];

  doCheck = true;
  checkInputs = [ ounit ];

  meta = {
    homepage = "https://github.com/burgerdev/ocaml-rfc7748";
    description = "Elliptic Curve Diffie-Hellman on Edwards Curves (X25519, X448)";
    longDescription = ''
      This library implements the ECDH functions 'X25519' and 'X448' as specified
      in RFC 7748, 'Elliptic curves for security'. In the spirit of the original
      publications, the public API is kept as simple as possible to make it easy
      to use and hard to misuse.
    '';
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ fufexan ];
  };
}
