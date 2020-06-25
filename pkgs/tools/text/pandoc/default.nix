{ stdenv, fetchzip }:

let
  version = "2.9.2.1";
  sources = {
    x86_64-linux = builtins.fetchurl {
      url =
        "https://github.com/jgm/pandoc/releases/download/${version}/pandoc-${version}-linux-amd64.tar.gz";
      sha256 = "1y0c9cdhk1w7l3qx3l265dzgjcb673qqhmxsnk0lhz9bpn0sjqav";
    };
    x86_64-darwin = fetchzip {
      url =
        "https://github.com/jgm/pandoc/releases/download/${version}/pandoc-${version}-macOS.zip";
      sha256 = "09idjjbz0dhiiydhwn9c87arf8l0c19rjypqjgwvyhn612l516j8";
    };
  };
in stdenv.mkDerivation rec {
  name = "pandoc-${version}";
  inherit version;
  src = sources.${stdenv.system};
  installPhase = ''
    mkdir -p $out
    cp -r bin/ share/ $out/
  '';

  # Don't touch the downloaded binaries
  dontFixup = true;
  dontStrip = true;
}
