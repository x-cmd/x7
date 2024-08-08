
BEGIN{
    true = 1
}

# $0~"^[A-Za-z0-9_-]+"{
#     print "\033[36;40;7;1m" $0 "\033[0m"
#     next
# }

BEGIN {
    CHAPTER = "(I|II|III|IV|V|VI|VII|VIII|IX|X|XI)"
    L = "\001"
}

function check_contents_str_trim(str){
    str = tolower( str )
    gsub(/^[ \r\t\b\v\n]+/, "", str)
    gsub(/[ \r\t\b\v\n.]+$/, "", str)
    gsub(/[ \r\t\b\v\n]+/, " ", str)

    gsub("^the ", "", str)
    return str
}

function is_contents(str,           i, l){
    str = check_contents_str_trim(str)
    if ( str == "" ) return 0

    l = contents[ L ]
    for (i=1; i<=l; i++) {
        if ( index( contents[i], str) ) return 1
    }
    return 0
}

function handle_contents(      _space_line ){
    while (getline) {
        if ( $0 ~ /^[ \t\r\n]+$/ )  {
            print $0
            _space_line ++
            continue
        }

        if ((contents[ L ] > 0 ) && ( _space_line >= 3 ))   break
        else if ( $0 ~ "EPILOGUE" )                         break
        else if ((contents[ L ] > 0 ) && \
            ( index(contents[1], check_contents_str_trim( $0 )) )) break

        print $0
        contents[ ++contents[ L ] ] = check_contents_str_trim($0)
        _space_line = 0
    }
}

{
    gsub("\\*+[^*]+\\*+", "\033[36m" "&" "\033[0m", $0)
    gsub("\\[+[^]]+\\]+", "\033[36m" "&" "\033[0m", $0)
    if ( tolower($0) ~ "^contents") {
        print "\033[32m" $0 "\033[0m"
        handle_contents()
    }

    if ( is_contents($0) ) print "\033[32m" $0 "\033[0m"
    else {
        print $0
    }
}
