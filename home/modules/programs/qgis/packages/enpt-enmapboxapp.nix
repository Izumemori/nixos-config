{
 fetchPypi,
 buildPythonPackage,
 setuptools,
 psutil
}:
buildPythonPackage rec {
  pname = "enpt-enmapboxapp";
  version = "0.8.6";
  pyproject = true;
  src = fetchPypi {
    pname = "enpt_enmapboxapp";
    inherit version;
    sha256 = "IcBtsr7GKuoQ0r2OInv76fdRmSTVuvibA7Rq6devRwM=";
  };

  build-system = [
    setuptools
  ];

  buildInputs = [
    psutil
  ];
}