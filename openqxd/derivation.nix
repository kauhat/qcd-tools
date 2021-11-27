{ stdenv, pkgs, lib }:

stdenv.mkDerivation rec {
  name = "openqxd";

  src = pkgs.fetchFromGitLab {
    owner = "rcstar";
    repo = "openQxD";
    rev = "d9920613801589a908069dbf59758e6e352b6465";
    sha256 = "0yhw6n6ip2q0sg13v64s5b1xwwsmk7drniv8fm8dc2jnr88as7fp";
  };

  buildInputs = [
    pkgs.mpich
    # pkgs.mpi
  ];

  GCC = "${pkgs.stdenv.cc.cc}/bin/gcc";
  MPI_HOME = "${pkgs.mpich}";
  MPI_INCLUDE = "${pkgs.mpich}/include";

  CFLAGS = toString [
    "-std=c89 -pedantic -fstrict-aliasing"
    # "-Wall -Wno-long-long -Wstrict-prototypes -Werror" # Seems to break build
    "-mno-avx -DAVX -DFMA3 -DPM"
    "-O"
  ];

  # hardeningDisable = [ "format" ];
  makeFlags = toString [ "--directory=./main" ];

  preBuild = ''
    # Hack: override CFLAGS set in makefile.
    makeFlagsArray+=(PREFIX="$out" CFLAGS="$NIX_CFLAGS_COMPILE $CFLAGS")
  '';

  installPhase = ''
    mkdir -p $out/bin
    find ./main -type f -executable -exec cp {} $out/bin/ \;

    mkdir -p $out/examples
    cp -r ./main/examples/. $out/examples
  '';

  meta = with lib; {
    description = "A versatile tool for QCD+QED simulations";
    homepage = "https://gitlab.com/rcstar/openQxD";
    license = licenses.gpl2Only;
  };
}
