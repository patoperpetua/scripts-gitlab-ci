#!/usr/bin/env bash

# Web Page of BASH best practices https://kvz.io/blog/2013/11/21/bash-best-practices/
#Exit when a command fails.
set -o errexit
#Exit when script tries to use undeclared variables.
set -o nounset
#The exit status of the last command that threw a non-zero exit code is returned.
set -o pipefail

#Trace what gets executed. Useful for debugging.
#set -o xtrace

# Set magic variables for current file & dir
__dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
__file="${__dir}/$(basename "${BASH_SOURCE[0]}")"
__base="$(basename "${__file}" .sh)"
__root="$(cd "$(dirname "${__dir}")" && pwd)"

echo "Script name: ${__base}"
echo "Executing at ${__root}"

if ! type "curl" &> /dev/null; then
    echo "curl is not installed. Install it and then re launch"
    exit 1
fi

BASE_FOLDER=".git/hooks/"
SCRIPT_NAME_S="bash_script_test_standalone.sh"
SCRIPT_PATH_S="${BASE_FOLDER}${SCRIPT_NAME_S}"
SCRIPT_NAME_G="gitlab-ci_lint_test_standalone.sh"
SCRIPT_PATH_G="${BASE_FOLDER}${SCRIPT_NAME_G}"

echo -ne "Checking script ${SCRIPT_NAME_S}..."
if [ ! -f "${SCRIPT_PATH_S}" ]; then
    echo "Not found, installing..."
    curl -o "${SCRIPT_PATH_S}" \
    -L https://singletonsd.gitlab.io/scripts/common/latest/${SCRIPT_NAME_S}
    chmod +x ${SCRIPT_PATH_S}
else
    echo "FOUND."
fi

echo -ne "Checking script ${SCRIPT_NAME_G}..."
if [ ! -f "${SCRIPT_PATH_G}" ]; then
    echo "Not found, installing..."
    curl -o "${SCRIPT_PATH_G}" \
    -L https://singletonsd.gitlab.io/scripts/gitlab-ci/latest/${SCRIPT_NAME_G}
    chmod +x ${SCRIPT_PATH_G}
else
    echo "FOUND."
fi

echo -ne "Cheking pre-commit file..."
if [ ! -f "${BASE_FOLDER}pre-commit" ]; then
    echo "not found, installing..."
    HOOK="${BASE_FOLDER}pre-commit"
    cat > "$HOOK" <<    EOF
#!/bin/sh

#Exit when a command fails.
set -o errexit

./.git/hooks/${SCRIPT_NAME_G}

if [ -d "examples" ]; then
    ./.git/hooks/${SCRIPT_NAME_G} -o=examples
fi

./.git/hooks/${SCRIPT_NAME_G} -o=.gitlab-ci.yml

if [ -f ".gitlab-ci.yml" ]; then
    ./.git/hooks/${SCRIPT_NAME_G} -o=.gitlab-ci.yml
fi
EOF
    chmod +x ${BASE_FOLDER}pre-commit
else
    echo "FOUND."
fi