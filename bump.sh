#!/usr/bin/env bash
# Bump version to ${1}

exit_on_error() {
  if [ "X${1}" != "X0" ]
  then
    echo "Command failed"
    exit ${1}
  fi
}

if [ "X${1}" = "X" ]
then
  echo "Usage: ${0} <version>"
  exit -1
else
  echo "Setting version to ${1}"

  cd "$( dirname "${BASH_SOURCE[0]}" )"
  exit_on_error $?

  echo "- meson.build"
  sed -i "s/version: '[a-zA-Z0-9][\.\a-zA-Z0-9]*'/version: '${1}'/g" meson.build
  exit_on_error $?

  echo "- src/config_def.py"
  sed -i "s/\"program_version\": ((\"wstring\",), (\"Qman [a-zA-Z0-9][\.\a-zA-Z0-9]*\",)/\"program_version\": ((\"wstring\",), (\"Qman ${1}\",)/g" src/config_def.py
  exit_on_error $?

  echo "- README.md"
  sed -i "s/Version [a-zA-Z0-9][\.\a-zA-Z0-9]* --/Version ${1} --/g" README.md
  exit_on_error $?

  echo "- man/qman.1.md"
  sed -i "s/footer: Qman [a-zA-Z0-9][\.\a-zA-Z0-9]*/footer: Qman ${1}/g" man/qman.1.md
  exit_on_error $?

  cd man
  ./build_man.sh
  exit_on_error $?
fi

