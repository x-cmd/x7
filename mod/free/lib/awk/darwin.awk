# shellcheck shell=awk
# macOS memory info parser - reads from vm_stat output and sysctl data via env
#
# Memory Conservation Law:
# wired + active + inactive + speculative + throttled + free + occupied = total

BEGIN {
    page_kb = 4096 / 1024
    total_kb = 0
    swap_line = ""

    sysctl_data = ENVIRON["___X_CMD_FREE_SYSCTL_DATA"]
    n = split(sysctl_data, lines, "\n")
    for (i = 1; i <= n; i++) {
        if (match(lines[i], /^hw\.pagesize: /)) {
            val = substr(lines[i], RLENGTH + 1)
            if (val > 0) page_kb = val / 1024
        } else if (match(lines[i], /^hw\.memsize: /)) {
            val = substr(lines[i], RLENGTH + 1)
            if (val > 0) total_kb = val / 1024
        } else if (match(lines[i], /^vm\.swapusage: /)) {
            swap_line = substr(lines[i], RLENGTH + 1)
        }
    }
}

/^Mach Virtual Memory Statistics/ {
    if (match($0, /page size of [0-9]+/)) {
        val = substr($0, RSTART + 12, RLENGTH - 12)
        if (val > 0) page_kb = val / 1024
    }
}

/Pages free/                    { pages_free = $3 }
/Pages active/                  { pages_active = $3 }
/Pages inactive/                { pages_inactive = $3 }
/Pages wired down/              { pages_wired = $4 }
/Pages purgeable/               { pages_purgeable = $3 }
/Pages speculative/             { pages_speculative = $3 }
/Pages throttled/               { pages_throttled = $3 }
/File-backed pages/             { pages_filebacked = $3 }
/Anonymous pages/               { pages_anonymous = $3 }
/Pages stored in compressor/    { compress_stored = $5 }
/Pages occupied by compressor/  { compress_occupied = $5 }

END {
    # Convert to KB
    free_kb = pages_free * page_kb
    active_kb = pages_active * page_kb
    inactive_kb = pages_inactive * page_kb
    wired_kb = pages_wired * page_kb
    speculative_kb = pages_speculative * page_kb
    throttled_kb = pages_throttled * page_kb
    purgeable_kb = pages_purgeable * page_kb
    filebacked_kb = pages_filebacked * page_kb
    anonymous_kb = pages_anonymous * page_kb
    compress_stored_kb = compress_stored * page_kb
    compress_occupied_kb = compress_occupied * page_kb

    # Logic layer calculations
    kernel_kb = wired_kb
    compressed_kb = compress_occupied_kb
    app_kb = anonymous_kb - purgeable_kb
    cache_kb = filebacked_kb
    available_kb = speculative_kb + throttled_kb + free_kb

    # Parse swap info from sysctl output
    swap_total_kb = 0
    swap_used_kb = 0
    if (swap_line != "") {
        swap_total_kb = parse_swap(swap_line, "total")
        swap_used_kb = parse_swap(swap_line, "used")
    }
    swap_free_kb = swap_total_kb - swap_used_kb

    # Compressor savings
    compress_saved_kb = compress_stored_kb - compress_occupied_kb

    # Colors
    init_colors(NO_COLOR)

    # Output
    if (format == "csv") {
        if (header == 1) print "total,wired,occupied,active,inactive,speculative,throttled,free,kernel,compressed,app,purgeable,cache,available,swap_total,swap_used,compress_stored,compress_occupied,compress_saved"
        printf "%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s\n",
            total_kb, wired_kb, compress_occupied_kb, active_kb, inactive_kb, speculative_kb, throttled_kb, free_kb,
            kernel_kb, compressed_kb, app_kb, purgeable_kb, cache_kb, available_kb,
            swap_total_kb, swap_used_kb, compress_stored_kb, compress_occupied_kb, compress_saved_kb
    } else if (format == "tsv") {
        if (header == 1) print "total\twired\toccupied\tactive\tinactive\tspeculative\tthrottled\tfree\tkernel\tcompressed\tapp\tpurgeable\tcache\tavailable\tswap_total\tswap_used\tcompress_stored\tcompress_occupied\tcompress_saved"
        printf "%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n",
            total_kb, wired_kb, compress_occupied_kb, active_kb, inactive_kb, speculative_kb, throttled_kb, free_kb,
            kernel_kb, compressed_kb, app_kb, purgeable_kb, cache_kb, available_kb,
            swap_total_kb, swap_used_kb, compress_stored_kb, compress_occupied_kb, compress_saved_kb
    } else {
        # Table format - Linux free style: Mem and Swap at top
        # Aligned with Phys/Logic rows (8 columns, first column is label)
        
        # Calculate "free" as available + purgeable + cache (user requested)
        est_free_kb = available_kb + purgeable_kb + cache_kb
        
        # Calculate used = total - free (for Mem)
        mem_used_kb = total_kb - est_free_kb
        
        # Leading empty line
        print ""
        
        # Header row (aligned with Phys/Logic: 9 columns total) - no bold
        printf("  " UI_HDR_OFF "%-8s %10s %10s %10s %10s %10s %10s %10s %10s" UI_END "\n",
            "", "total", "used", "reusable", "", "", "", "", "")
        
        # Mem row (aligned columns: label, total, used, free, then 5 empty cols)
        # After free value, add dim hint: (available + cache + purgeable)
        if (NO_COLOR == 1) {
            printf("  %-8s %10s %10s %10s (=purgeable + cache + available)\n",
                "Mem:",
                fmt_human_val(total_kb),
                fmt_human_val(mem_used_kb),
                fmt_human_val(est_free_kb))
        } else {
            # Color Mem: label (cyan), total (bold), used (bold red), free (bold green)
            printf("  %s%-8s%s %s%10s%s %s%10s%s %s%10s%s" UI_DIM " (=purgeable + cache + available)" UI_END "\n",
                UI_KEY, "Mem:", UI_END,
                UI_HDR, fmt_human_val(total_kb), UI_END,
                UI_BOLD_RED, fmt_human_val(mem_used_kb), UI_END,
                UI_BOLD_GREEN, fmt_human_val(est_free_kb), UI_END)
        }
        
        # Swap row (same alignment)
        swap_str = sprintf("%-8s %10s %10s %10s %10s %10s %10s %10s %10s",
            "Swap:",
            fmt_human_val(swap_total_kb),
            fmt_human_val(swap_used_kb),
            fmt_human_val(swap_free_kb),
            "", "", "", "", "")
        gsub(/Swap:/, UI_KEY "Swap:" UI_END, swap_str)
        print "  " swap_str
        
        # Separator line
        print ""
        
        # Identity: app + purgeable + cache = active + inactive
        # Logic Layer (primary view) - available aligns with free (column 6)
        print ""
        if (NO_COLOR == 1) {
            printf("  %-8s %10s %10s %10s %10s %10s %10s %10s %10s\n",
                "", "wired", "compressed", "app", "purgeable", "cache", "available", "", "")
            printf("  %-8s %10s %10s %10s %10s %10s %10s (=free + spec + throt)\n",
                "Detail:",
                fmt_human_val(kernel_kb),
                fmt_human_val(compressed_kb),
                fmt_human_val(app_kb),
                fmt_human_val(purgeable_kb),
                fmt_human_val(cache_kb),
                fmt_human_val(available_kb))
        } else {
            printf("  %s%-8s%s %s%10s%s %s%10s%s %s%10s%s %s%10s%s %s%10s%s %s%10s%s %s%10s%s %s%10s%s\n",
                UI_DIM, "", UI_END,
                UI_DIM, "wired", UI_END,
                UI_DIM, "compressed", UI_END,
                UI_DIM UI_UNDERLINE, "app", UI_UNDERLINE_OFF UI_END,
                UI_DIM UI_UNDERLINE, "purgeable", UI_UNDERLINE_OFF UI_END,
                UI_DIM UI_UNDERLINE, "cache", UI_UNDERLINE_OFF UI_END,
                UI_DIM, "available", UI_END,
                "", "", UI_END,
                "", "", UI_END)
            printf("  %s%-8s%s %s%10s%s %s%10s%s %s%10s%s %s%10s%s %s%10s%s %s%10s%s" UI_DIM " (=free + spec + throt)" UI_END "\n",
                UI_KEY, "Detail:", UI_END,
                UI_RED, fmt_human_val(kernel_kb), UI_END,
                UI_RED, fmt_human_val(compressed_kb), UI_END,
                UI_RED, fmt_human_val(app_kb), UI_END,
                UI_GREEN, fmt_human_val(purgeable_kb), UI_END,
                UI_GREEN, fmt_human_val(cache_kb), UI_END,
                UI_GREEN, fmt_human_val(available_kb), UI_END)
        }
        
        # Physical Layer (reference - vm_stat raw counters) - free before spec
        print ""
        if (NO_COLOR == 1) {
            printf("  %-8s %10s %10s %10s %10s %10s %10s %10s %10s\n",
                "", "wired", "compressed", "active", "inactive", "-", "free", "spec", "throt")
            printf("  %-8s %10s %10s %10s %10s %10s %10s %10s %10s\n",
                "vm_stat",
                fmt_human_val(wired_kb),
                fmt_human_val(compress_occupied_kb),
                fmt_human_val(active_kb),
                fmt_human_val(inactive_kb),
                "-",
                fmt_human_val(free_kb),
                fmt_human_val(speculative_kb),
                fmt_human_val(throttled_kb))
        } else {
            printf("  %s%-8s%s %s%10s%s %s%10s%s %s%10s%s %s%10s%s %s%10s%s %s%10s%s %s%10s%s %s%10s%s\n",
                UI_DIM, "", UI_END,
                UI_DIM, "wired", UI_END,
                UI_DIM, "compressed", UI_END,
                UI_DIM UI_UNDERLINE, "active", UI_UNDERLINE_OFF UI_END,
                UI_DIM UI_UNDERLINE, "inactive", UI_UNDERLINE_OFF UI_END,
                UI_DIM, "-", UI_END,
                UI_DIM, "free", UI_END,
                UI_DIM, "spec", UI_END,
                UI_DIM, "throt", UI_END)
            printf("  %s%-8s%s %s%10s%s %s%10s%s %s%10s%s %s%10s%s %s%10s%s %s%10s%s %s%10s%s %s%10s%s\n",
                UI_DIM, "vm_stat", UI_END,
                UI_DIM, fmt_human_val(wired_kb), UI_END,
                UI_DIM, fmt_human_val(compress_occupied_kb), UI_END,
                UI_DIM, fmt_human_val(active_kb), UI_END,
                UI_DIM, fmt_human_val(inactive_kb), UI_END,
                UI_DIM, "-", UI_END,
                UI_GREEN, fmt_human_val(free_kb), UI_END,
                UI_GREEN, fmt_human_val(speculative_kb), UI_END,
                UI_GREEN, fmt_human_val(throttled_kb), UI_END)
        }

        # Compress info (dimmed)
        if (NO_COLOR == 1) {
            printf("  %-8s %10s %10s %10s %10s %10s %10s %10s %10s\n",
                "", "", "compressed", "original", "ratio", "saved", "", "", "")
            compress_str = sprintf("%-8s %10s %10s %10s %10s %10s %10s %10s %10s",
                "",
                "",
                fmt_human_val(compress_occupied_kb),
                fmt_human_val(compress_stored_kb),
                "0%",
                fmt_human_val(compress_saved_kb),
                "", "", "")
            print "  " compress_str
        } else {
            ratio_str = "0%"
            if (compress_stored_kb > 0) {
                ratio = (compress_occupied_kb / compress_stored_kb) * 100
                ratio_str = sprintf("%.0f%%", ratio)
            }
            printf("  " UI_DIM "%-8s %10s %10s %10s %10s %10s %10s %10s %10s" UI_END "\n",
                "", "", "compressed", "original", "ratio", "saved", "", "", "")
            printf("  " UI_DIM "%-8s %10s %10s %10s %10s %10s %10s %10s %10s" UI_END "\n",
                "",
                "",
                fmt_human_val(compress_occupied_kb),
                fmt_human_val(compress_stored_kb),
                ratio_str,
                fmt_human_val(compress_saved_kb),
                "", "", "")
        }
        # Add empty line for separation in repeat mode (-c)
        print ""
    }
}

function parse_swap(line, key,   i, n, arr, val, matched, num_len, j, c, num, unit) {
    n = split(line, arr, " ")
    for (i = 1; i <= n; i++) {
        if (arr[i] == key && arr[i+1] == "=") {
            val = arr[i+2]
            if (match(val, /^[0-9.]+[KMGT]/)) {
                matched = substr(val, RSTART, RLENGTH)
                num_len = 0
                for (j = 1; j <= length(matched); j++) {
                    c = substr(matched, j, 1)
                    if ((c >= "0" && c <= "9") || c == ".") {
                        num_len++
                    } else {
                        break
                    }
                }
                num = substr(matched, 1, num_len)
                unit = substr(matched, num_len + 1, 1)
                if (unit == "K") return int(num)
                else if (unit == "M") return int(num * 1024)
                else if (unit == "G") return int(num * 1024 * 1024)
                else if (unit == "T") return int(num * 1024 * 1024 * 1024)
            }
        }
    }
    return 0
}
