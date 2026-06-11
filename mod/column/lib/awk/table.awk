# table.awk — invoked by ___x_cmd_column___table from lib/main.
#
# Variables (set with -v by the shell wrapper):
#   delim_re       regex char class like "[:]" or "" for whitespace mode
#   delim_was_set  "1" if -s was given, "0" if whitespace mode
#   outsep         output column separator (default "  ")
#   squeeze        "1" to collapse runs of delimiters, "0" to keep empties
#   color          "1" to wrap alternating rows with ANSI reverse video (7m)
#
# Style policy: when color is on, row 1 (the title/header) gets a
# single `\033[7m ... \033[0m` wrap — 标题反色. All other rows are
# plain. Padding math uses the raw cell length so alignment stays
# clean under the embedded escape codes.

BEGIN {
    nrows = 0
    ncols = 0
    if (delim_was_set == "1") {
        FS = delim_re
    } else if (squeeze == "1") {
        FS = "[ \t]+"
    } else {
        FS = "[ \t]"
    }
    if (color == "1") {
        RESET   = sprintf("%c[0m", 27)
        REVERSE = sprintf("%c[7m", 27)
    } else {
        RESET = REVERSE = ""
    }
}
{
    line = $0
    if (delim_was_set == "0") {
        sub(/^[ \t]+/, "", line)
        sub(/[ \t]+$/, "", line)
    } else {
        sub(/[ \t]+$/, "", line)
    }

    nf = (line == "" ? 0 : split(line, parts, FS))
    nrows++
    if (nf > ncols) ncols = nf
    for (i = 1; i <= nf; i++) {
        w = length(parts[i])
        if (w + 0 > maxw[i] + 0) maxw[i] = w
        cell[nrows, i] = parts[i]
    }
}
END {
    if (nrows == 0) exit 0
    gap = length(outsep)
    if (gap < 1) { outsep = "  "; gap = 2 }
    for (r = 1; r <= nrows; r++) {
        out = ""
        for (i = 1; i <= ncols; i++) {
            v = (((r, i) in cell) ? cell[r, i] : "")
            vlen = length(v)
            out = out v
            if (i < ncols) {
                target = maxw[i] + gap
            } else {
                target = vlen
            }
            pad = target - vlen
            while (pad-- > 0) out = out " "
        }
        sub(/[ \t]+$/, "", out)
        if (color == "1" && r == 1) out = REVERSE out RESET
        print out
    }
}
