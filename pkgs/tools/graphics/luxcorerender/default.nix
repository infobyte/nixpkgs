{ stdenv, fetchFromGitHub, cmake, boost165, pkgconfig, python36
, tbb, openimageio, libjpeg, libpng, zlib, libtiff, ilmbase
, freetype, openexr, libXdmcp, libxkbcommon, epoxy, at-spi2-core
, dbus, doxygen, qt5, c-blosc, libGLU, gnome3, dconf, gtk3, pcre
, bison, flex, libpthreadstubs, libX11
, embree2, makeWrapper, gsettings-desktop-schemas, glib
, withOpenCL ? true , opencl-headers, ocl-icd, opencl-clhpp
}:

let
      python = python36;

      boost_static = boost165.override {
      inherit python;
      enableStatic = true;
      enablePython = true;
    };

    version = "2.0";
    sha256 = "15nn39ybsfjf3cw3xgkbarvxn4a9ymfd579ankm7yjxkw5gcif38";

in stdenv.mkDerivation {
  pname = "luxcorerender";
  inherit version;

  src = fetchFromGitHub {
    owner = "LuxCoreRender";
    repo = "LuxCore";
    rev = "luxcorerender_v${version}";
    inherit sha256;
  };

  buildInputs =
   [ embree2 pkgconfig cmake zlib boost_static libjpeg
     libtiff libpng ilmbase freetype openexr openimageio
     tbb qt5.full c-blosc libGLU pcre bison
     flex libX11 libpthreadstubs python libXdmcp libxkbcommon
     epoxy at-spi2-core dbus doxygen
     # needed for GSETTINGS_SCHEMAS_PATH
     gsettings-desktop-schemas glib gtk3
     # needed for XDG_ICON_DIRS
     gnome3.adwaita-icon-theme
     makeWrapper
     (stdenv.lib.getLib dconf)
   ] ++ stdenv.lib.optionals withOpenCL [opencl-headers ocl-icd opencl-clhpp];

  cmakeFlags = [
    "-DOpenEXR_Iex_INCLUDE_DIR=${openexr.dev}/include/OpenEXR"
    "-DOpenEXR_IlmThread_INCLUDE_DIR=${ilmbase.dev}/include/OpenEXR"
    "-DOpenEXR_Imath_INCLUDE_DIR=${openexr.dev}/include/OpenEXR"
    "-DOpenEXR_half_INCLUDE_DIR=${ilmbase.dev}/include"
    "-DPYTHON_LIBRARY=${python}/lib/libpython3.so"
    "-DPYTHON_INCLUDE_DIR=${python}/include/python${python.pythonVersion}"
    "-DEMBREE_INCLUDE_PATH=${embree2}/include"
    "-DEMBREE_LIBRARY=${embree2}/lib/libembree.so"
    "-DBoost_PYTHON_LIBRARY_RELEASE=${boost_static}/lib/libboost_python3-mt.so"
  ] ++ stdenv.lib.optional withOpenCL
       "-DOPENCL_INCLUDE_DIR=${opencl-headers}/include";
  preConfigure = ''
    NIX_CFLAGS_COMPILE+=" -isystem ${python}/include/python${python.pythonVersion}"
    NIX_LDFLAGS+=" -lpython3"
  '';

  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/lib
    cp -va bin/* $out/bin
    cp -va lib/* $out/lib
  '';

  preFixup = ''
    wrapProgram "$out/bin/luxcoreui" \
      --prefix XDG_DATA_DIRS : "$GSETTINGS_SCHEMAS_PATH" \
      --suffix XDG_DATA_DIRS : '${gnome3.adwaita-icon-theme}/share' \
      --prefix GIO_EXTRA_MODULES : "${stdenv.lib.getLib dconf}/lib/gio/modules"
  '';

  meta = with stdenv.lib; {
    broken = true;
    description = "Open source, physically based, unbiased rendering engine";
    homepage = "https://luxcorerender.org/";
    maintainers = with maintainers; [ hodapp ];
    license = licenses.asl20;
    platforms = platforms.linux;
  };
}


# TODO (might not be necessary):
#
# luxcoreui still gives warnings like: "failed to commit changes to
# dconf: GDBus.Error:org.freedesktop.DBus.Error.ServiceUnknown: The
# name ca.desrt.dconf was not provided by any .service files"

# CMake complains of the FindOpenGL/GLVND preference
