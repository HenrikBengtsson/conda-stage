pwd=${BASH_SOURCE%/*}

# shellcheck source=incl/asserts.sh
source "${pwd}"/asserts.sh

function change_dir {
    local opwd
    opwd=${PWD}
    assert_dir_exists "$1"
    cd "$1" || error "Failed to set working directory to $1"
    mdebug "New working directory: '$1' (was '${opwd}')"
}

function make_dir {
    mkdir -p "$1" || error "Failed to create new working directory $1"
}

function remove_dir {
    rm -rf "$1" || error "Failed to remove directory $1"
}

function equal_dirs {
    local a
    local b
    a=$(readlink -f "$1")
    b=$(readlink -f "$2")
    [[ "${a}" == "${b}" ]]
}

function wait_for_file {
    local file
    local maxseconds
    local delay
    
    file=${1:?}
    maxseconds=${2:-300}
    delay=${3:-1.0}
    
    t0=${SECONDS}
    until [[ -f "${file}" && $((SECONDS - t0)) -lt "${maxseconds}" ]]; do
        sleep "${delay}"
    done
    [[ -f "${file}" ]] || error "Waited for file ${file}, but gave up after ${maxseconds} seconds"
}
