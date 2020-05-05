{ stdenv }:

stdenv.mkDerivation rec {
  name = "pandoc-${version}";
  version = "2.9.2.1";
  src = builtins.fetchurl {
    url =
      "https://github.com/jgm/pandoc/releases/download/${version}/pandoc-${version}-linux-amd64.tar.gz";
    sha256 = "1y0c9cdhk1w7l3qx3l265dzgjcb673qqhmxsnk0lhz9bpn0sjqav";
  };
  installPhase = ''
    mkdir -p $out
    cp -r bin/ share/ $out/
  '';

  # Don't touch the downloaded binaries
  dontFixup = true;
  dontStrip = true;
}
