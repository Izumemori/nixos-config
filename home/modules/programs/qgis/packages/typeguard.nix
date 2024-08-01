{
 fetchPypi,
 buildPythonPackage,
 setuptools,
 setuptools-scm
}:
buildPythonPackage rec {
  pname = "typeguard";
  version = "2.13.3";
  pyproject = true;
  src = fetchPypi {
    inherit pname version;
    sha256 = "AO2qjaOhM2dHls9eqH2fS0w2fXdHbhhegCUcwT37uMQ=";
  };

  build-system = [
    setuptools
  ];

  nativeBuildInputs = [
    setuptools-scm
  ];
}