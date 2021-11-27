with import <nixpkgs>{};

stdenv.mkDerivation {
    name = "qcdtools";

    dontUnpack = true;
    dontInstall = true;

    # installPhase = ''
    #     mkdir -p $out
    # '';
}
