#!/usr/bin/env bash

# where is history written to?
BASH_LOG=~/history.txt

# dimensions
NUM_HISTORY_LINES=5
WINDOW_WIDTH=50

# 6 is cyan
HISTORY_FONT_COLOR=6

#-------------------------------------------------------------------------------
# below here hopefully nothing to adapt

print_line () {
    local row=$((1 + $1))
    local col=$2

    # move cursor to specific position
    echo -ne "\033[${row};${col}H"

    local string_length=${#4}
    local window_with_buffer=$((${WINDOW_WIDTH} + 2))
    local padding_length=$((${window_with_buffer} - ${string_length}))
    local padding=$(printf '%.0s ' $(seq 1 ${padding_length}))
    local string_with_padding="${4}${padding}"
    local trimmed_string="${string_with_padding:0:${window_with_buffer}}"

    printf '%s%s%s' "$3" "${trimmed_string}" "$5"
}

show_history_block() {
    # save the current cursor position
    echo -ne "\033[s"

    # save the default color
    default_color=$(tput sgr0)

    # change the font color
    color=$(tput setaf ${HISTORY_FONT_COLOR})
    echo -n "${color}"

    local terminal_width=$(tput cols)
    local col=$((${terminal_width} - ${WINDOW_WIDTH} - 4))
    local width_with_padding=$((${WINDOW_WIDTH} + 2))

    local repeated_chars=$(printf '%.0s_' $(seq 1 ${width_with_padding}))
    print_line 0 ${col} " " "${repeated_chars}" " "

    for (( i = 1; i <= ${NUM_HISTORY_LINES}; i++ )); do
        local depth=$((${NUM_HISTORY_LINES} + 1 - $i))
        local line=$(tail -n ${depth} ${BASH_LOG} | head -n 1)
        print_line $i ${col} "|" " ${line}" "|"
    done

    local repeated_chars=$(printf '%.0s‾' $(seq 1 ${width_with_padding}))
    print_line $((1 + ${NUM_HISTORY_LINES})) ${col} " " "${repeated_chars}" " "

    # restore the default font color
    echo -n "${default_color}"

    # restore the cursor to the previous position
    echo -ne "\033[u"
}

bash_log_commands () {
    # https://superuser.com/questions/175799
    [ -n "$COMP_LINE" ] && return  # do nothing if completing
    [[ "$PROMPT_COMMAND" =~ "$BASH_COMMAND" ]] && return # don't cause a preexec for $PROMPT_COMMAND
    local this_command=`HISTTIMEFORMAT= history 1 | sed -e "s/^[ ]*[0-9]*[ ]*//"`;
    echo "$this_command" >> "$BASH_LOG"
}

trap 'bash_log_commands' DEBUG

export PROMPT_COMMAND=show_history_block
