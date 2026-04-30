BEGIN{
    start_line = ENVIRON[ "start_line" ]
    end_line = ENVIRON[ "end_line" ]
    is_recent = false
    if ( end_line == "" ) is_recent = true

    Q0 = SUBSEP "\"1\""
    QBODY = Q0 SUBSEP "\"body\""
}

(NR >= start_line) && ( is_recent || (NR <= end_line) ){
    parse_item($0)
}

function parse_item( s,        o, kp, l, i, item_type, item_text, msg_type, msg_text, msg_img_url, msg_img_aeskey, ref_str){
    jiparse_after_tokenize(o, s)
    JITER_LEVEL = JITER_CURLEN = 0

    # Default values
    msg_type = ""
    msg_text = ""
    msg_img_url = ""
    msg_img_aeskey = ""

    msgid = juq( o[ QBODY SUBSEP "\"msgid\"" ] )
    from_userid = juq( o[ QBODY SUBSEP "\"from\"", "\"userid\"" ] )
    chatid = juq( o[ QBODY SUBSEP "\"chatid\"" ] )
    chattype = juq( o[ QBODY SUBSEP "\"chattype\"" ] )
    msg_type = juq( o[ QBODY SUBSEP "\"msgtype\"" ] )
    response_url = juq( o[ QBODY SUBSEP "\"response_url\"" ] )

    if ( msg_type == "text" ){
        msg_text = juq( o[ QBODY SUBSEP "\"text\"", "\"content\"" ] )
        if ( msg_text != "" ){
            msg_text = parse_tsv_esc( msg_text )
        }
    }
    else if ( msg_type == "mixed" ){
        l = o[ QBODY SUBSEP "\"mixed\"" SUBSEP "\"msg_item\"" L ]
        for (i=1; i<=l; ++i){
            kp = QBODY SUBSEP "\"mixed\"" SUBSEP "\"msg_item\"" SUBSEP sprintf("\"%d\"", i)
            item_type = o[ kp SUBSEP "\"msgtype\"" ]

            if (item_type == "\"text\""){
                item_text = juq( o[ kp SUBSEP "\"text\"", "\"content\"" ] )
                if ( item_text != "" ){
                    item_text = parse_tsv_esc( item_text )
                }
                ref_str = ref_str item_text
            }
            else if (item_type == "\"image\""){
                msg_img_url = juq( o[ kp SUBSEP "\"image\"", "\"url\"" ] )
                msg_img_aeskey = juq( o[ kp SUBSEP "\"image\"", "\"aeskey\"" ] )
            }
        }
        msg_text = ref_str
    }

    print msgid
    print from_userid
    print chatid
    print chattype
    print msg_type
    print msg_text
    print msg_img_url
    print msg_img_aeskey
    print response_url
}

function parse_tsv_esc( v ){
    if (v ~ /[\r\n\t\\]/) {
        gsub( "\\\\", "&\\", v )
        gsub( "\r", "\\r",  v )
        gsub( "\n", "\\n",  v )
        gsub( "\t", "\\t",  v )
    }
    return v
}
