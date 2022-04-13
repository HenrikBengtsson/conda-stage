# -------------------------------------------------------------------------
# SYSTEM
#
# Requirements:
# * asserts.sh
# -------------------------------------------------------------------------
pwd=${BASH_SOURCE%/*}

# shellcheck source=incl/asserts.sh
source "${pwd}"/asserts.sh

## A version of 'hostname' that will use either $HOSTNAME or hostname
function hostname {
    local res
    res=${HOSTNAME}
    [[ -z ${res} ]] && res=$(command hostname)
    [[ -z ${res} ]] && error "Failed to infer hostname"
    echo "${res}"
}
