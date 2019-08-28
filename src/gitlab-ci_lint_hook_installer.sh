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
SCRIPT_NAME="gitlab-ci_lint_test_standalone.sh"
SCRIPT_PATH="${BASE_FOLDER}${SCRIPT_NAME}"

echo -ne "Checking script..."
if [ ! -f "${SCRIPT_PATH}" ]; then
    echo "Not found, installing..."
    curl -o "${SCRIPT_PATH}" \
    -L https://singletonsd.gitlab.io/scripts/gitlab-ci/latest/gitlab-ci_lint_test_standalone.sh
    chmod +x ${SCRIPT_PATH}
else
    echo "FOUND."
fi

echo -ne "Cheking pre-commit file..."
if [ ! -f "${BASE_FOLDER}pre-commit" ]; then
    echo "not found, installing..."
    HOOK="${BASE_FOLDER}pre-commit"
    cat > "$HOOK" <<    EOF
    #!/bin/sh
    ./.git/hooks/${SCRIPT_NAME}
EOF

    chmod +x ${BASE_FOLDER}pre-commit
else
    echo "FOUND."
fi