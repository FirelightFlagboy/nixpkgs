{
  lib,
  buildDunePackage,
  ocaml,
  saturn_lockfree,
  domain_shims,
  dscheck,
  multicore-bench,
  qcheck,
  qcheck-alcotest,
  qcheck-stm,
}:

buildDunePackage {
  pname = "saturn";

  inherit (saturn_lockfree) src version;

  propagatedBuildInputs = [ saturn_lockfree ];

  doCheck = lib.versionAtLeast ocaml.version "5.0";
  checkInputs = [
    domain_shims
    dscheck
    multicore-bench
    qcheck
    qcheck-alcotest
    qcheck-stm
  ];

  meta = saturn_lockfree.meta // {
    description = "Parallelism-safe data structures for multicore OCaml";
  };

}
