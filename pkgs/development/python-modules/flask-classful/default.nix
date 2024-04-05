# WARNING: This file was automatically generated. You should avoid editing it.
# If you run pynixify again, the file will be either overwritten or
# deleted, and you will lose the changes you made to it.

{ buildPythonPackage, fetchPypi, flask, lib }:

buildPythonPackage rec {
  pname = "flask-classful";
  version = "0.16.0";

  src = fetchPypi {
    inherit version;
    pname = "flask_classful";
    sha256 = "1man85snz3al89gnh2vhf18im47ivy5z90frhkd03qsrbxqdqwwh";
  };

  propagatedBuildInputs = [ flask ];

  # TODO FIXME
  doCheck = false;

  meta = with lib; { };
}
