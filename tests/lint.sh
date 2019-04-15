#!/usr/bin/env bash
# This script look for suspicious items in the repository.
# No formulas, roles, or any states are executed. This is only a first check.
# The primary purpose of this is to provide a cheaper way to test simple things before getting to Docker.


set -u
set -e
set -o pipefail

readonly PILLAR='./pillar'
readonly FORMULA='./formulas'


# Ensure no bad file modes e.g. 0644 that are not quoted.
test_bad_file_mode() {
  local error_count=0
  echo -en "\tChecking for un-quoted zeroes in file mode..."
  local files=$(find ./formulas -type f -name '*.sls')
  for file in $files; do
    modes=$(awk '/- mode:/ {print $3}' $file)
    for mode in $modes; do
      if [[ $mode == 0* ]]; then
         echo -ne "\n\t\x1b[31;01mFile $file has incorrect mode set: $mode\x1b[9;49;00m\n"
        ((error_count++))
      fi
    done
  done
  if [[ error_count -gt 0 ]]; then
    return 1
  fi
  echo -e "\t\x1b[32;01mOK\x1b[9;49;00m"
}


# Check that the pillar files are valid YAML.
test_pillar_compilation() {
  local errors=$(mktemp)
  echo -en "\tMaking sure pillar files compile..."
  for file in $(find $PILLAR -type f -name '*sls'); do
    # Execute each check in a separate process to speed things up.
    (
      local tmpfile=$(mktemp)
      python tests/strip_jinja.py $file > $tmpfile
      python -c "import yaml; yaml.load(open('$tmpfile', 'r').read())"
      if [[ $? -ne 0 ]]; then
        echo -e "\n\t\x1b[31;01mPillar '$file' does not compile.\x1b[9;49;00m"
        echo $file >> $errors
      fi
      shebang=$(head -n1 ${file} | grep -o '^[#][!]')
      jinja_shebang=$(head -n1 ${file} | grep -o jinja)
      if [ -n "${shebang}" -a -z "${jinja_shebang}" ] ; then
        if [ -n "$(grep -Eo '[{]{2}|[{][%#]' ${file})" -a -n "$(grep -Eo '[}]{2}|[}][%#]' ${file})" ] ; then
          echo -e "\n\t\x1b[31;01mPillar '$file' appears to contain jinja without a jinja shebang.\x1b[9;49;00m"
          echo ${file}} >> $errors
        fi
      fi
      rm -f $tmpfile
    ) &
  done
  wait
  error_count=$(wc -l $errors | awk '{print $1}')
  rm -f $errors
  if [[ error_count -gt 0 ]]; then
    return 1
  fi
  echo -e "\t\x1b[32;01mOK\x1b[9;49;00m"
}


# Ensure pillar files with encrypted values have a proper heading for rendering.
test_pillar_encrypted_pillars() {
  local error_count=0
  echo -en "\tChecking for GPG header for pillars with encrypted values..."
  for pillar in $(grep -lr PGP $PILLAR); do
    grep '#!yaml|gpg' $pillar >/dev/null || grep '#!jinja|yaml|gpg' $pillar >/dev/null
    if [[ $? -ne 0 ]]; then
      echo -e "\n\x1b[31;01mPillar '$pillar' does not have the '#!yaml|gpg' header.\x1b[9;49;00m"
      ((error_count++))
    fi
  done
  if [[ error_count -gt 0 ]]; then
    return 1
  fi
  echo -e "\t\x1b[32;01mOK\x1b[9;49;00m"
}


# Ensure each formula has an example pillar file.
test_missing_example_pillar() {
  local error_count=0
  echo -en "\tChecking for missing pillar.example files in formulas..."
  for formula in $FORMULA/*; do
    ls -1 $formula/pillar.example > /dev/null 2>&1
    if [[ $? -ne 0 ]]; then
      echo -e "\n\t\x1b[31;01mFormula '$formula' does not have a pillar.example file.\x1b[9;49;00m"
      ((error_count++))
    fi
  done
  if [[ error_count -gt 0 ]]; then
    return 1
  fi
  echo -e "\t\x1b[32;01mOK\x1b[9;49;00m"
}


# Roles and formulas cannot be identically named. This ensures no conflicts exist.
test_name_conflicts() {
  echo -en "\tChecking for role/formula name conflicts..."
  role_name_conflicts=$(for formula in $(ls -1 $FORMULA/); do ls -1 salt/roles/${formula}.sls 2>/dev/null; done)
  conflict_count=$(echo $role_name_conflicts | grep sls | wc -l)

  if [[ $conflict_count -gt 0 ]]; then
    echo -e "\n\t\x1b[31;01mThe following roles have a formula with the same name.\x1b[9;49;00m"
    echo -e "\t\t$role_name_conflicts"
    return 1
  fi
  echo -e "\t\x1b[32;01mOK\x1b[9;49;00m"
}


main() {
  echo "Running lint checks..."
  test_name_conflicts || exit 1
  test_missing_example_pillar || exit 1
  test_bad_file_mode || exit 1
  test_pillar_encrypted_pillars || exit 1
  test_pillar_compilation || exit 1
}

main $@
