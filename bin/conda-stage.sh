#! /usr/bin/env bash

CONDA_STAGE_HOME=$(dirname "$(dirname "${BASH_SOURCE%/}")")
[[ -L "${CONDA_STAGE_HOME}" ]] && CONDA_STAGE_HOME=$(readlink "${CONDA_STAGE_HOME}")
CONDA_STAGE_HOME=$(realpath "${CONDA_STAGE_HOME}")

function conda-stage() {
    local tf_res
    local tf_log
    local exit_code
    local cmd
    local debug
    
    if [[ -z "${CONDA_STAGE_HOME}" ]]; then
        echo >&2 "ERROR: [INTERNAL] CONDA_STAGE_HOME not set"
        return 1
    fi

    ## Import bash utility functions
    incl="${CONDA_STAGE_HOME}/bin/incl"

    # shellcheck source=incl/asserts.sh
    source "${incl}/asserts.sh"
    # shellcheck source=incl/cli.sh
    source "${incl}/cli.sh"
    # shellcheck source=incl/conditions.sh
    source "${incl}/conditions.sh"
    # shellcheck source=incl/files.sh
    source "${incl}/files.sh"
    # shellcheck source=incl/output.sh
    source "${incl}/output.sh"
    # shellcheck source=incl/ports.sh
    source "${incl}/ports.sh"
    # shellcheck source=incl/system.sh
    source "${incl}/system.sh"

    debug=${CONDA_STAGE_DEBUG:-false}
    
    mdebug "conda-stage() ..."
    
    tf_res=$(mktemp)
    tf_log=$(mktemp)

    ## Stage to local disk
    CONDA_STAGE_LOGFILE="${tf_log}" "${CONDA_STAGE_HOME}/bin/conda-stage" "$@" 1> "$tf_res"
    exit_code=$?
    if [[ $exit_code -ne 0 ]]; then
        cat "$tf_res"
        rm -f "$tf_res" "$tf_log"
        return "$exit_code"
    elif [[ ! -f "$tf_log" ]]; then
        (merror "[INTERNAL] Failed to infer conda-stage log")
        rm -f "$tf_res"
        return 2
    elif [[ ! -f "$tf_res" ]]; then
        (merror "[INTERNAL] Failed to infer conda-stage path")
        rm -f "$tf_log"
        return 2
    fi

    ## Parse log file
    action=$(grep -E "^action:" "$tf_log" | sed -E 's/^action:[[:space:]]*//')
    mdebug "action='${action}'"
    rm "${tf_log}"
    if [[ -z "$action" ]]; then
        (merror "[INTERNAL] Failed to infer conda-stage action")
        rm -f "$tf_res"
        return 2
    fi

    if [[ $action = "stage" ]] || [[ $action = "unstage" ]]; then
        cmd=$(cat "$tf_res")
        rm "${tf_res}"
        if [[ -z $cmd ]]; then
            (merror "[INTERNAL] Failed to infer conda-stage 'activate' file. Empty result")
            return 2
        fi

        mdebug "cmd='${cmd}'"

        ## WORKAROUND: This will make the PS1 prompt for the original
        ## conda environment be correct when unstaging. /HB 2022-04-13
        if [[ $action == "unstage" ]]; then
            conda deactivate
            exit_code=$?
        fi
        
        eval "$cmd"
        exit_code=$?
        
        ## WORKAROUND: This will make the PS1 prompt for the staged
        ## conda environment be correct when staging. /HB 2022-04-13
        if [[ $action == "stage" ]]; then
            eval "$cmd"
            exit_code=$?
        fi
    else
        ## For all other actions, echo the captured standard output
        cat "${tf_res}"
        rm "${tf_res}"
    fi
    
    mdebug "conda-stage() ... done (exit_code=$exit_code)"
    return "$exit_code"
}
