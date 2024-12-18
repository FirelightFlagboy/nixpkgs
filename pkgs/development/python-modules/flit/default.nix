{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  docutils,
  requests,
  pytestCheckHook,
  testpath,
  responses,
  flit-core,
  tomli-w,
}:

# Flit is actually an application to build universal wheels.
# It requires Python 3 and should eventually be moved outside of
# python-packages.nix. When it will be used to build wheels,
# care should be taken that there is no mingling of PYTHONPATH.

buildPythonPackage rec {
  pname = "flit";
  version = "3.9.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "pypa";
    repo = "flit";
    rev = version;
    hash = "sha256-yl2+PcKr7xRW4oIBWl+gzh/nKhSNu5GH9fWKRGgaNHU=";
  };

  patches = [
    # https://github.com/pypa/flit/commit/6ab62c91d0db451b5e9ab000f0dba5471550b442.patch
    ./python314-compat.patch
  ];

  nativeBuildInputs = [ flit-core ];

  propagatedBuildInputs = [
    docutils
    requests
    flit-core
    tomli-w
  ];

  nativeCheckInputs = [
    pytestCheckHook
    testpath
    responses
  ];

  disabledTests = [
    # needs some ini file.
    "test_invalid_classifier"
    # calls pip directly. disabled for PEP 668
    "test_install_data_dir"
    "test_install_module_pep621"
    "test_symlink_data_dir"
    "test_symlink_module_pep621"
  ];

  meta = with lib; {
    changelog = "https://github.com/pypa/flit/blob/${version}/doc/history.rst";
    description = "Simple packaging tool for simple packages";
    mainProgram = "flit";
    homepage = "https://github.com/pypa/flit";
    license = licenses.bsd3;
  };
}
