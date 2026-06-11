# fill.awk — invoked by ___x_cmd_column___fill from lib/main.
#
# Variables (set with -v by the shell wrapper):
#   width   output width in columns (used to choose side-by-side count).
#           Defaults to 80 when unset / invalid.
#
# Each input line is one entry. We compute the widest entry, decide
# how many side-by-side columns fit in `width`, then fill column-first
# (matches GNU `column` without -x): the first N lines go in column 1,
# the next N in column 2, etc.
#
# No per-row state survives between lines; padding is recomputed in
# the END block from the full list.

BEGIN {
    if (width == "" || width + 0 < 1) width = 80
    nlines = 0
    maxw = 0
}
{
    nlines++
    lines[nlines] = $0
    w = length($0)
    if (w > maxw) maxw = w
}
END {
    if (nlines == 0) exit 0
    gap = 2
    col_w = maxw + gap
    if (col_w < 1) col_w = 1
    ncols = int((width + gap) / col_w)
    if (ncols < 1) ncols = 1
    if (ncols > nlines) ncols = nlines
    rows_per_col = int((nlines + ncols - 1) / ncols)
    if (rows_per_col < 1) rows_per_col = 1

    for (r = 1; r <= rows_per_col; r++) {
        out = ""
        for (c = 1; c <= ncols; c++) {
            idx = (c - 1) * rows_per_col + r
            if (idx > nlines) break
            cell = lines[idx]
            if (c < ncols) {
                target = maxw + gap
            } else {
                target = length(cell)
            }
            out = out cell
            pad = target - length(cell)
            while (pad-- > 0) out = out " "
        }
        sub(/[ \t]+$/, "", out)
        print out
    }
}
