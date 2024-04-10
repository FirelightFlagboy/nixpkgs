{
  lib,
  fetchFromGitHub,
  # Plover is currently tested with python 3.10 and do not seems to work with more recent versions
  # https://github.com/openstenoproject/plover/commits/a8ac3631bee1971eec2b41b74fbebdad4750291a
  python310Packages,
  mkDerivationWith,
}:

{
  stable = throw "plover.stable was removed because it used Python 2. Use plover.dev instead."; # added 2022-06-05

  dev =
    let
      inherit (python310Packages)
        appdirs
        babel
        buildPythonPackage
        mock
        pyqt5
        pyserial
        pytest
        setuptools
        wcwidth
        xlib
        stdenv
        ;
      inherit (lib) licenses maintainers platforms;
      plover_stroke = mkDerivationWith buildPythonPackage rec {
        pname = "plover_stroke";
        version = "1.1.0";

        pyproject = true;

        src = fetchFromGitHub {
          owner = "openstenoproject";
          repo = "plover_stroke";
          rev = "refs/tags/${version}";
          sha256 = "sha256-A75OMzmEn0VmDAvmQCp6/7uptxzwWJTwsih3kWlYioA=";
        };

        nativeCheckInputs = [ pytest ];
        propagatedBuildInputs = [ setuptools ];

        pythonImportsCheck = [ "plover_stroke" ];

        meta = {
          description = "Stroke handling helper library for Plover";
          license = licenses.gpl2Plus;
          homepage = "https://github.com/openstenoproject/plover_stroke";
          platforms = platforms.linux ++ platforms.windows;
          maintainers = [ maintainers.FirelightFlagboy ];
        };
      };

      rtf_tokenize = mkDerivationWith buildPythonPackage rec {
        pname = "rtf_tokenize";
        version = "1.0.0";

        pyproject = true;

        src = fetchFromGitHub {
          owner = "openstenoproject";
          repo = "rtf_tokenize";
          rev = "refs/tags/${version}";
          sha256 = "sha256-zwD2sRYTY1Kmm/Ag2hps9VRdUyQoi4zKtDPR+F52t9A=";
        };

        nativeCheckInputs = [ pytest ];
        propagatedBuildInputs = [ setuptools ];

        pythonImportsCheck = [
          "rtf_tokenize"
        ];

        meta = {
          description = "Simple RTF tokenizer";
          license = licenses.gpl2Plus;
          homepage = "https://github.com/openstenoproject/rtf_tokenize";
          platforms = platforms.linux ++ platforms.windows;
          maintainers = [ maintainers.FirelightFlagboy ];
        };
      };
    in
    mkDerivationWith buildPythonPackage rec {
      pname = "plover";
      version = "4.0.0.dev12";

      pyproject = true;

      src = fetchFromGitHub {
        owner = "openstenoproject";
        repo = "plover";
        rev = "refs/tags/v${version}";
        sha256 = "sha256-qK6Z97r5dr5Hr0JkY5WaqYE67FEiXi12Pu7Y+wS0Zm4=";
      };

      nativeCheckInputs = [
        pytest
        mock
      ];
      propagatedBuildInputs = [
        babel
        pyqt5
        xlib
        pyserial
        appdirs
        wcwidth
        setuptools
        plover_stroke
        rtf_tokenize
      ];

      dontWrapQtApps = true;

      preFixup = ''
        makeWrapperArgs+=("''${qtWrapperArgs[@]}")
      '';

      meta = {
        mainProgram = "plover";
        broken = stdenv.hostPlatform.isDarwin;
        description = "OpenSteno Plover stenography software";
        homepage = "https://www.openstenoproject.org/plover/";
        maintainers = builtins.attrValues {
          inherit (maintainers) FirelightFlagboy twey kovirobi;
        };
        license = licenses.gpl2Plus;
      };
    };
}
