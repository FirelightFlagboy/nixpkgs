{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,

  # propagates
  importlib-metadata,

  # tests
  editables,
  gitMinimal,
  mercurial,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pdm-backend";
  version = "2.4.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pdm-project";
    repo = "pdm-backend";
    tag = version;
    hash = "sha256-OeS1PqcWXJdvSEZwkBEHGJSYM6bX7QSPdfs9u06g760=";
  };

  env.PDM_BUILD_SCM_VERSION = version;

  dependencies = lib.optionals (pythonOlder "3.10") [ importlib-metadata ];

  pythonImportsCheck = [ "pdm.backend" ];

  nativeCheckInputs = [
    editables
    gitMinimal
    mercurial
    pytestCheckHook
    setuptools
  ];

  preCheck = ''
    unset PDM_BUILD_SCM_VERSION

    # tests require a configured git identity
    export HOME=$TMPDIR
    git config --global user.name nixbld
    git config --global user.email nixbld@localhost
  '';

  setupHook = ./setup-hook.sh;

  meta = with lib; {
    homepage = "https://github.com/pdm-project/pdm-backend";
    changelog = "https://github.com/pdm-project/pdm-backend/releases/tag/${version}";
    description = "Yet another PEP 517 backend";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
