#! /usr/bin/env bash

CONDA_STAGE=$(dirname "${BASH_SOURCE%/}")
[[ -L "${CONDA_STAGE}" ]] && CONDA_STAGE=$(readlink "${CONDA_STAGE}")
CONDA_STAGE=$(realpath "${CONDA_STAGE}/conda-stage")

function conda-stage() {
    local tf
    local activate_file

    if [[ -z "${CONDA_STAGE}" ]]; then
        echo >&2 "INTERNAL ERROR: CONDA_STAGE not set"
        return 1
    fi

    tf=$(mktemp)
    
    ## Stage to local disk
    if ! "${CONDA_STAGE}" "$@" > "$tf"; then
        rm -f "$tf"
        return 1
    fi
    
    if [[ ! -f "$tf" ]]; then
        echo >&2 "INTERNAL ERROR: Failed to infer conda-stage path"
        return 1
    fi
    
    ## Activate local disk
    mapfile -t activate_file < <(cat "$tf")
    rm "${tf}"
    
    if [[ "${#activate_file[@]}" -eq 0 ]]; then
        echo >&2 "INTERNAL ERROR: Failed to infer conda-stage 'activate' file. Empty result."
        return 1
    elif [[ "${#activate_file[@]}" -gt 1 ]]; then
        echo >&2 "INTERNAL ERROR: Failed to infer conda-stage 'activate' file. Too many results (n=${#activate_file[@]})"
        return 1
    elif [[ ! -f "${activate_file[0]}" ]]; then
        echo >&2 "INTERNAL ERROR: conda-stage 'activate' file does not exist: ${activate_file[0]}"
        return 1
    fi

    # shellcheck source=/dev/null
    source "${activate_file[0]}"
}
