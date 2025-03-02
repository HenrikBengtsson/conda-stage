# -------------------------------------------------------------------------
# CLI utility functions
# -------------------------------------------------------------------------
function version {
    grep -E "^#'[ ]*Version:[ ]*" "$0" | sed "s/#'[ ]*Version:[ ]*//g"
}

function help {
    local what res

    what=$1
    if [[ $what == "full" ]]; then
        res=$(grep -E "^#['\"]" "$0" | grep -vE "^(#' whatis: )" | cut -b 4-)
    else
        res=$(grep -E "^#'" "$0" | grep -vE "^(#' whatis: )" | cut -b 4-)
    fi

    printf "%s\\n" "${res[@]}"
}
