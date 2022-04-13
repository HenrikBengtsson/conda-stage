# -------------------------------------------------------------------------
# PORTS
#
# Requirements:
# * python
# * asserts.sh
# -------------------------------------------------------------------------
pwd=${BASH_SOURCE%/*}

# shellcheck source=incl/asserts.sh
source "${pwd}"/asserts.sh

## Usage:
## find_free_port <seed> <algorithm> <skip> <min> <max>
## If 'seed' is not set, then no random seed is set.
## Outputs a free port in [1024,65535].
function find_free_port {
    local port
    local seed
    local skip
    local min
    local max
    local algorithm
    seed=${1:-}
    algorithm=${2:-random}
    skip=${3:-0}
    min=${4:-1024}
    max=${5:-65535}

    mdebug "find_free_port(seed=${seed}, algorithm='${algorithm}', skip=${skip}, min=${min}, max=${max}) ..."
    
    [[ -n "${seed}" ]] && assert_integer "${seed}"
    assert_port "${min}"
    assert_port "${max}"
    assert_executable python

    ## Check a single port?
    if [[ ${max} -eq ${min} ]]; then
        mdebug "- Check a single port ${min}:"
        code="import socket\ns=socket.socket(socket.AF_INET, socket.SOCK_STREAM)\nif (s.connect_ex(('', ${min})) != 0):\n  print(${min})\nelse:\n  print(False)\ns.close()"
    elif [[ "${algorithm}" == "random" ]]; then
        mdebug "- Algorithm '${algorithm}':"
        if [[ -z ${seed} && ${min} -eq 1024 && ${max} -eq 65535 ]]; then
            mdebug "- Ask system for a random port by binding to port 0"
            # get unused socket per https://unix.stackexchange.com/a/132524
            # tiny race condition between the Python and launching the rserver
            code="import socket; s=socket.socket(); s.bind(('', 0)); print(s.getsockname()[1]); s.close()"
        elif [[ -z ${seed} ]]; then
            mdebug "- Random port in {${min}, ..., ${max}} without a seed"
            code="import random\nimport socket\ns=socket.socket(socket.AF_INET, socket.SOCK_STREAM)\nfor ii in range(0,1000):\n  port=random.randrange(${min},${max})\n  if s.connect_ex(('', port)) != 0: break\nprint(port)"
        else
            mdebug "- Random port in {${min}, ..., ${max}} with seed=${seed}"
            code="import random\nimport socket\ns=socket.socket(socket.AF_INET, socket.SOCK_STREAM)\nrandom.seed(${seed})\nfor ii in range(0,1000):\n  port=random.randrange(${min},${max})\n  if ii >= ${skip} and s.connect_ex(('', port)) != 0: break\nprint(port)"
        fi
    elif [[ "${algorithm}" == "increasing" || "${algorithm}" == "decreasing" ]]; then
        mdebug "- Algorithm '${algorithm}':"
        range=${min}+${skip},${max},+1
        if [[ "${algorithm}" == "decreasing" ]]; then
            range=${max}-${skip},${min},-1
        fi
        mdebug "${range}"
        code="import socket\ns=socket.socket(socket.AF_INET, socket.SOCK_STREAM)\nfor port in range(${range}):\n  if s.connect_ex(('', port)) != 0: break\nprint(port)\n"
    else
        error "Unknown value on --algorithm=\"${algorithm}\""
    fi

    mdebug "${code}"
    [[ -z ${code} ]] && error "[INTERNAL] No Python code"
    
    #shellcheck disable=SC2059
    port=$(printf "${code}" | python -)
    mdebug "port=${port}"

    ## Failed to find a free port?
    if [[ "${port}" == "False" ]]; then
        mdebug "Failed to find a free port in {${min}, ..., ${max}}"
        echo "-1"
        res=1
    else
        assert_port "${port}"
        is_port_free "${port}" || error "Identified a free port, which now appears to be occupied: ${port}"
        echo "${port}"
        res=0
    fi

    mdebug "find_free_port(seed=${seed}, algorithm=${algorithm}, skip=${skip}, min=${min}, max=${max}) ... done"
    
    return "${res}"
}    

## Usage: is_port_free <port>
function is_port_free {
    local port
    local res
    port=${1:?}
    assert_integer "${port}"
    assert_executable python
    res=$(python -c "import socket; s=socket.socket(socket.AF_INET, socket.SOCK_STREAM); print(s.connect_ex(('', ${port})) != 0); s.close()")
    [[ "${res}" == "True" ]]
}

function assert_port {
    [[ -z $1 ]] && error "Port must not be empty"
    assert_integer "$1"
    if [[ $1 -lt 1 ]] || [[ $1 -gt 65535 ]]; then
        error "Port out of range [1,65535]: $1"
    fi
}

function assert_port_free {
    assert_port "${1}"
    is_port_free "$1" || error "Port is already in use on $(hostname): ${1}"
}
