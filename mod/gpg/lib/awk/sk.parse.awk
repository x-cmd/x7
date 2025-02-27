function trim( s ){
    gsub("(^[ \t]+)|([ \t]+)$", "", s)
    return s
}

BEGIN{
    while (getline) {
        result[ l+1, "fp" ] = $0
        if (! getline)    exit
        if (! getline)    exit

        l += 1
        $1 = "";
        result[ l, "sec"    ]   = trim( $0 )

        if (! getline)    exit
        result[ l, "keyid"  ]   = trim( $0 )

        if (! getline)    exit
        $1 = "";
        result[ l, "uid"    ]   = trim( $0 )

        if (! getline)    exit
        $1 = "";
        result[ l, "ssb"    ]   = trim( $0 )
    }
}

END {
    fmt = "%s\t%s\t%s\t%s\t%s\n"
    printf(fmt, "i", "keyid", "uid", "sec", "ssb")
    for (i=1; i<=l; ++i) {
        printf(fmt, i, result[ i, "keyid"], result[ i, "uid"], result[ i, "sec"], result[ i, "ssb"])
    }
}
