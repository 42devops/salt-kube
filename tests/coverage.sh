#!/usr/bin/env bash
# Determine the amount of coverage we have for state testing.


formula_coverage() {
  local states=$(find ./formulas/ -name *sls | wc -l)
  local tests=$(find ./formulas/*/tests -name *yaml 2>/dev/null | wc -l)
  local coverage=$(python -c "print(round(($tests/$states.0)*100, 1))")
  echo "${coverage}% of formulas are covered by a test."
}


role_coverage() {
  local states=$(find ./salt/roles/ -name *sls | wc -l)
  local tests=$(find ./salt/roles/*/tests -name *yaml 2>/dev/null | wc -l)
  local coverage=$(python -c "print(round(($tests/$states.0)*100, 1))")
  echo "${coverage}% of roles are covered by a test."
}


main() {
  formula_coverage
  role_coverage
}

main $@
