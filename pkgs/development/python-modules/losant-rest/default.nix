{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,
  requests,
  requests-mock,
  setuptools,
}:

buildPythonPackage rec {
  pname = "losant-rest";
  version = "1.19.9";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "Losant";
    repo = "losant-rest-python";
    rev = "refs/tags/v${version}";
    hash = "sha256-rokoecBjBrk0iYbsGFkpSVZK5UcEw62TRGwLl8uaSAw=";
  };

  build-system = [ setuptools ];

  dependencies = [ requests ];

  nativeCheckInputs = [
    pytestCheckHook
    requests-mock
  ];

  pytestFlagsArray = [ "tests/platformrest_tests.py" ];

  pythonImportsCheck = [ "platformrest" ];

  meta = with lib; {
    description = "Python module for consuming the Losant IoT Platform API";
    homepage = "https://github.com/Losant/losant-rest-python";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
