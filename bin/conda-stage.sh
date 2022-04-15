#! /usr/bin/env bash

CONDA_STAGE=$(dirname "${BASH_SOURCE%/}")
[[ -L "${CONDA_STAGE}" ]] && CONDA_STAGE=$(readlink "${CONDA_STAGE}")
CONDA_STAGE=$(realpath "${CONDA_STAGE}/conda-stage")

function conda-stage() {
    local tf_res
    local tf_log
    local exit_code
    local cmd
    local debug

    debug=${CONDA_STAGE_DEBUG:-false}
    
    if [[ -z "${CONDA_STAGE}" ]]; then
        echo >&2 "INTERNAL ERROR: CONDA_STAGE not set"
        return 1
    fi

    tf_res=$(mktemp)
    tf_log=$(mktemp)

    ## Stage to local disk
    CONDA_STAGE_LOGFILE="${tf_log}" "${CONDA_STAGE}" "$@" 1> "$tf_res"
    exit_code=$?
    if [[ $exit_code -ne 0 ]]; then
        cat "$tf_res"
        rm -f "$tf_res" "$tf_log"
        return "$exit_code"
    elif [[ ! -f "$tf_log" ]]; then
        echo >&2 "INTERNAL ERROR: Failed to infer conda-stage log"
        rm -f "$tf_res"
        return 2
    elif [[ ! -f "$tf_res" ]]; then
        echo >&2 "INTERNAL ERROR: Failed to infer conda-stage path"
        rm -f "$tf_log"
        return 2
    fi

    ## Parse log file
    action=$(grep -E "^action:" "$tf_log" | sed -E 's/^action:[[:space:]]*//')
    rm "${tf_log}"
    if [[ -z "$action" ]]; then
        echo >&2 "INTERNAL ERROR: Failed to infer conda-stage action"
        rm -f "$tf_res"
        return 2
    fi

    if [[ $action = "stage" ]] || [[ $action = "unstage" ]]; then
        cmd=$(cat "$tf_res")
        rm "${tf_res}"
        if [[ -z $cmd ]]; then
            echo >&2 "INTERNAL ERROR: Failed to infer conda-stage 'activate' file. Empty result."
            return 2
        fi

        if $debug; then
            echo >&2 "DEBUG: cmd=${cmd}"
        fi

        ## WORKAROUND: This will make the PS1 prompt for the original
        ## conda environment be correct when unstaging. /HB 2022-04-13
        if [[ $action == "unstage" ]]; then
            conda deactivate
        fi
        
        eval "$cmd"
        
        ## WORKAROUND: This will make the PS1 prompt for the staged
        ## conda environment be correct when staging. /HB 2022-04-13
        if [[ $action == "stage" ]]; then
            eval "$cmd"
        fi
    else
        ## For all other actions, echo the captured standard output
        cat "${tf_res}"
        rm "${tf_res}"
        return "$exit_code"
    fi
}
