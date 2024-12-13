
function printrow( i ){
    for (i=1; i<NF; ++i) printf("%s" ofs, $i)
    printf("%s\n", $NF)
}

function getline_or_exit( ){
    if (! getline) exit
}

function handletable( type, printheader, i ){
    num = NF

    if (printheader) {
        printf("%s" ofs, "type")
        printrow( )
    }
    getline_or_exit()

    while ($0 != "") {
        printf("%s" ofs, type)
        printrow( )
        getline_or_exit()
    }
}

BEGIN {

    ofs = ","

    while ($0 !~ /^[^:]+:/) getline_or_exit()
    getline_or_exit()

    handletable( "ipv4", 1 )

    while ($0 !~ /^[^:]+:/) getline_or_exit()
    getline_or_exit()

    handletable( "ipv6", "" )
}

