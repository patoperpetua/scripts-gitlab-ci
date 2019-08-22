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

GITLAB_VERSION="v0.2.2"
GITLAB_EXECUTE="gitlab"

if ! type "$GITLAB_EXECUTE" &> /dev/null; then
    GITLAB_EXECUTE="binaries/gitlab"
    if ! type "$GITLAB_EXECUTE" &> /dev/null; then
        if ! type "curl" &> /dev/null; then
            echo "curl is not installed. Install it and then re launch"
            exit 1
        fi
        mkdir -p binaries
        curl -L "https://github.com/Code0x58/gitlab-ci-validate/releases/download/${GITLAB_VERSION}/gitlab-ci-validate_linux_amd64" \
        -o binaries/gitlab
        chmod +x binaries/gitlab
    fi
fi

BINARY_NAME="$GITLAB_EXECUTE"

SRC_FOLDER="src"

function usage(){
    echo -e "-h | --help: display help."
    echo -e "-o | --only: the name of the file or folder to test."
}

while [ "${1+x}" != "" ]; do
    PARAM=$(echo "$1" | awk -F= '{print $1}')
    VALUE=$(echo "$1" | awk -F= '{print $2}')
    case $PARAM in
        -h | --help)
            usage
            exit
            ;;
        -o | --only)
            SRC_FOLDER=$VALUE
            ;;
        *)
            echo "ERROR: unknown parameter \"$PARAM\""
            usage
            exit 1
            ;;
    esac
    shift
done

if [ "${BINARY_NAME}" == "" ]; then
    echo "ERROR: Binary name not provided"
    exit 1
fi

if ! type "${BINARY_NAME}" &> /dev/null; then
    echo "ERROR: ${BINARY_NAME} is not installed. Install it and then re launch"
    exit 1
fi

if [ -f "${SRC_FOLDER}" ]; then
    eval "$BINARY_NAME ${SRC_FOLDER}"
else
    shopt -s dotglob
    for SINGLE_FILE in "${SRC_FOLDER}"/*
    do
        echo "Checking ${SINGLE_FILE}..."
        eval "$BINARY_NAME $SINGLE_FILE"
    done
fi
