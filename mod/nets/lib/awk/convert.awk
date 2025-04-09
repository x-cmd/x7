
BEGIN{
    datadir = ENVIRON[ "datadir" ]

    getline
    while (1) {
        if ($0 ~ /^Active[ ]Internet/) {
            handle_internet()
        } else if ($0 ~ /Active[ ]UNIX/) {
            handle_unix()
        } else if ($0 ~ /Active[ ]LOCAL/) {
            handle_local()
        } else if ($0 ~ /^Active[ ]Connections/) {
            handle_connection()
        } else if ($0 ~ /^Active[ ]kernel[ ]event/) {
            handle_kernel_event()
        } else if ($0 ~ /^Active[ ]kernel[ ]control/) {
            handle_kernel_control()
        } else {
            if (!getline) break
        }
    }
}

function repeat( time, word,        i, s ){
    s = ""
    for (i=1; i<=time; ++i) {
        s = s "%s\t"
    }

    return s
}

function handle_internet(){
    title = $0
    getline
    header = $0
    gsub(/Local[ ]+Address/, "Local-Address", header)
    gsub(/Foreign[ ]+Address/, "Foreign-Address", header)

    $0 = header
    fields = $0

    fmt = repeat( 11, "%s\t" ) "%s\n"

    printf(fmt,     \
        "proto", "recvq", "sendq", "local", "foreign", "state", "rhiwat", "shiwat", "pid", "epid", "state", "option" \
    ) >>(datadir "/internet")

    while (getline) {
        if ( ($1 == "Active") || ($1 == "Registered") )     break

        proto = $1
        recvq = $2
        sendq = $3
        local = $4
        foreign = $5

        if (proto ~ /udp/) {
            state = ""
            base = 6
        } else {
            state = $6
            base = 7
        }

        rhiwat = $base
        shiwat = $(base+1)
        pid = $(base+2)
        epid = $(base+3)
        state = $(base+4)
        option = $(base+5)

        printf(fmt, \
            proto, recvq, sendq, local, foreign, state, rhiwat, shiwat, pid, epid, state, option \
        ) >>(datadir "/internet")
    }
}

# linux
function handle_unix(){
    title = $0
    getline
    header = $0
    fmt = repeat( 6, "%s\t" ) "%s\n"

    printf(fmt,     "proto", "refcnt", "flags", "type", "state", "inode", "path" )>>(datadir "/domain")

    while (getline) {
        if ( ($1 == "Active") || ($1 == "Registered") )     break

        proto   = $1
        refcnt  = $2
        flags   = $3
        type    = $4

        state   = $5
        if (state ~ /[0-9]+/) {
            state = ""
            inode = $5
            path = $6   # ""
        } else {
            inode   = $6
            $1 = $2 = $3 = $4 = $5 = $6 = ""
            gsub(/(^[ ]+)|([ ]+$)/, "", $0)
            path    = $0
        }

        printf( fmt, proto, refcnt, flags, type, state, inode, path \
        ) >>(datadir "/domain")
    }
}

# macos
function handle_local(){
    title = $0
    getline
    header = $0

    fmt = repeat( 8, "%s\t" ) "%s\n"

    printf(fmt,     \
        "addr", "type", "recvq", "sendq", "inode", "conn", "refs", "nextref", "fp" \
    )>>(datadir "/domain")

    while (getline) {
        if ( ($1 == "Active") || ($1 == "Registered") )     break

        addr    = $1
        type    = $2
        recvq   = $3
        sendq   = $4
        inode   = $5
        conn    = $6
        refs    = $7
        nextref = $8
        fp      = $9

        printf( fmt, \
            addr, type, recvq, sendq, inode, conn, refs, nextref, fp \
        ) >>(datadir "/domain")
    }
}

# Just windows
function handle_connection(){
    getline
    getline

    header = $0

    fmt = repeat( 3, "%s\t" ) "%s\n"

    printf(fmt,     "proto", "local", "foreign", "state" )>>(datadir "/internet")

    while (getline) {
        if ( ($1 == "Active") || ($1 == "Registered") )     break
        proto   = $1
        local   = $2
        foreign = $3
        state   = $4

        printf( fmt, proto, local, foreign, state ) >>(datadir "/internet")
    }
}

function handle_kernel_event(){
    title = $0
    getline
    header = $0

    fmt = repeat( 9, "%s\t" ) "%s\n"

    printf(fmt, "proto", "recvq", "sendq", "vendor", "class", "subcl", "rhiwat", "shiwat", "pid", "epid") >>(datadir "/kernel_event")

    while (getline) {
        if ( ($1 == "Active") || ($1 == "Registered") )     break
        proto   = $1
        recvq   = $2
        sendq   = $3
        vendor  = $4
        class   = $5
        subcl   = $6
        rhiwat  = $7
        shiwat  = $8
        pid     = $9
        epid    = $10

        printf( fmt, proto, recvq, sendq, vendor, class, subcl, rhiwat, shiwat, pid, epid ) >>(datadir "/kernel_event")
    }
}

function handle_kernel_control(){
    title = $0
    getline
    header = $0

    fmt = repeat( 9, "%s\t" ) "%s\n"

    printf(fmt, "proto", "recvq", "sendq", "rhiwat", "shiwat", "pid", "epid", "unit", "id", "name") >>(datadir "/kernel_control")

    while (getline) {
        if ( ($1 == "Active") || ($1 == "Registered") )     break
        proto   = $1
        recvq   = $2
        sendq   = $3
        rhiwat  = $4
        shiwat  = $5
        pid     = $6
        epid    = $7
        unit    = $8
        id      = $9
        name    = $10

        printf( fmt, proto, recvq, sendq, rhiwat, shiwat, pid, epid, unit, id, name ) >>(datadir "/kernel_control")
    }
}


