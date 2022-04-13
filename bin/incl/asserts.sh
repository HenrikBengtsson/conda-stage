# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# ASSERTIONS
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
## Usage: assert_file_exists /path/to/file
function assert_file_exists {
    [[ $# -ne 1 ]] && error "${FUNCNAME[0]}() requires a single argument: $#"
    [[ -n "$1" ]] || error "File name must be non-empty: '$1'"
    [[ -f "$1" ]] || error "No such file: '$1' (working directory '${PWD}')"
}

function assert_link_exists {
    [[ $# -ne 1 ]] && error "${FUNCNAME[0]}() requires a single argument: $#"
    [[ -n "$1" ]] || error "File name must be non-empty: '$1'"
    [[ -L "$1" ]] || error "File is not a link: '$1' (working directory '${PWD}')"
    [[ -e "$1" ]] || error "[File] link is broken: '$1' (working directory '${PWD}')"
}

## Usage: assert_file_executable /path/to/file
function assert_file_executable {
    [[ $# -ne 1 ]] && error "${FUNCNAME[0]}() requires a single argument: $#"
    assert_file_exists "$1"
    [[ -x "$1" ]] || error "File exists but is not executable: '$1' (working directory '${PWD}')"
}

## Usage: assert_dir_exists /path/to/folder
function assert_dir_exists {
    [[ $# -ne 1 ]] && error "${FUNCNAME[0]}() requires a single argument: $#"
    [[ -n "$1" ]] || error "Directory name must be non-empty: '$1'"
    [[ -d "$1" ]] || error "No such directory: '$1' (working directory '${PWD}')"
}

## Usage: assert_executable command
function assert_executable {
  command -v "${1:?}" &> /dev/null || error "No such executable: ${1}"
}

## Usage: assert_executable string
function assert_integer {
    echo "${1:?}" | grep -q -E "^[[:digit:]]+$" || error "Not an integer: ${1}"
}
