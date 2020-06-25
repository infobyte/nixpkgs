{ stdenv }:

let
  version = "2.9.2.1";
  sources = {
    x86_64-linux = builtins.fetchurl {
      url =
        "https://github.com/jgm/pandoc/releases/download/${version}/pandoc-${version}-linux-amd64.tar.gz";
      sha256 = "1y0c9cdhk1w7l3qx3l265dzgjcb673qqhmxsnk0lhz9bpn0sjqav";
    };
    x86_64-darwin = builtins.fetchurl {
      url =
        "https://github.com/jgm/pandoc/releases/download/${version}/pandoc-${version}-macOS.zip";
      sha256 = "01skcwv80im08xg352wyxv1f99nqjrc505ywp38sf0kadrx7z164";
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
