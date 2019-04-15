#!/usr/bin/env bash
# This script will apply each formula in a seperate Docker container and ensure defined tests pass.

set -u
set -e
set -o pipefail


readonly ROLES='./salt/roles'
readonly FORMULAS='./formulas'
readonly LATEST_COMMIT=$(git log |head -n1 | awk '{print $1}' | cut -c1-8)


# Check to see if docker is installed.
docker_installed() {
  echo -en "\tChecking if Docker is installed..."
  which docker >/dev/null
  if [[ $? -ne 0 ]]; then
    echo -e "\t\x1b[31;01mFAIL\x1b[9;49;00m"
    return 1
  fi
  echo -e "\t\x1b[32;01mOK\x1b[9;49;00m"
}


# Check to see if docker is running.
docker_running() {
  echo -en "\tChecking if Docker is running..."
  docker ps >/dev/null
  if [[ $? -ne 0 ]]; then
    echo -e "\t\x1b[31;01mFAIL\x1b[9;49;00m"
    return 1
  fi
  echo -e "\t\x1b[32;01mOK\x1b[9;49;00m"
}


build_docker_image() {
  local latest_commit=$(git log |head -n1 | awk '{print $1}' | cut -c1-8)
  docker build -t $latest_commit ./ > /tmp/docker_build.log
  echo $latest_commit
}

# Check each formula with tests defined in docker.
test_formulas() {
  echo -en "\tBuilding Docker image from commit $LATEST_COMMIT..."
  local image=$(build_docker_image)
  if [[ $? -ne 0 ]]; then
    echo -e "\t\x1b[31;01mFAIL\x1b[9;49;00m"
    return 1
  fi
  echo -e "\t\x1b[32;01mOK\x1b[9;49;00m"
  local test_formula_calls=""
  local testable_formulas=$(find formulas/ -mindepth 2 -maxdepth 2 -type d -name tests)
  local init_test=""
  local install_test=""
  local remaining_tests=""
  for f in ${testable_formulas} ; do
    test_formula_calls=""
    init_test=$(find ${f}/ -mindepth 1 -maxdepth 1 -type f -name init.yaml)
    if [ -n "${init_test}" ] ; then
      local init_formula=$(echo $init_test | cut -d\/ -f2,4 | sed 's/\.yaml//' | sed 's;/;.;'  | sed 's/\.init//')
      test_formula_calls="${test_formula_calls}$init_test "
    fi
    install_test=$(find ${f}/ -mindepth 1 -maxdepth 1 -type f -name install.yaml)
    if [ -n "${install_test}" ] ; then
      local install_formula=$(echo $install_test | cut -d\/ -f2,4 | sed 's/\.yaml//' | sed 's;/;.;')
      test_formula_calls="${test_formula_calls}$install_test "
    fi
    local remaining_tests=$(find ${f}/ -mindepth 1 -maxdepth 1 -type f -name '*.yaml' '!' -name init.yaml '!' -name install.yaml)
    if [ -n "${remaining_tests}" ] ; then
      for t in ${remaining_tests} ; do
        local test_formula=$(echo $t | cut -d\/ -f2,4 | sed 's/\.yaml//' | sed 's;/;.;'  | sed 's/\.init//')
        test_formula_calls="${test_formula_calls}$t "
      done
    fi
    test_formula_calls=$(printf "%s\n" "${test_formula_calls}" | sed -r -e 's/ +$//g')
    if [ -n "${test_formula_calls}" ] ; then
      echo -e "Testing formulas with string \"/tmp/test_formula.sh ${test_formula_calls}\"..."
      docker run --rm $image /tmp/test_formula.sh ${test_formula_calls}
      exit_code="${?}"
      if [[ ${exit_code} -ne 0 ]]; then
        echo -e "\n\t\x1b[31;01mTests within \"${test_formula_calls}\" failed.\x1b[9;49;00m"
        return ${exit_code}
      fi
    fi
  done
}

main() {
  echo "Running Docker based tests..."
  docker_installed || exit 1
  docker_running || exit 1
  test_formulas || exit 1
}

main
