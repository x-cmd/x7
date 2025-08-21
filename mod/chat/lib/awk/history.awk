

# o is [ { ... } ]

# req.json
# res.json
function chat_history_load( o, chatid, session_dir, history_num, form_startpoint,     _cmd, t, i, l, kp, kp_i, _, found_startpoint ){
    kp = chatid
    if ( o[ kp ] == "[" ) return

    _cmd = "{ command find " qu1(session_dir) " -name \"chat.response.yml\"" " | command sort -r; } 2>/dev/null"
    l = 0
    if (history_num > 0) {
        while( ( _cmd | getline t ) > 0 ){
            match(t, "/[^/]+/chat.response.yml")
            t = substr(t, RSTART+1)
            gsub("/.*$", "", t)
            if ( t == chatid ) {
                found_startpoint = 1
                continue
            }
            if (( ! form_startpoint ) || ( found_startpoint )) {
                _[ ++l ] = t
                if (l >= history_num) break
            }
        }
    }
    close( _cmd )
    o[ kp ] = "["
    for (i=1; i<=l; ++i){
        jlist_put(o, kp, "{")
        kp_i = kp SUBSEP "\""i"\""
        jdict_put(o, kp_i, "\"creq\"", "{" )
        jdict_put(o, kp_i, "\"cres\"", "{" )

        t = _[ l - i + 1 ]
        creq_loadfromjsonfile( o, kp_i SUBSEP "\"creq\"",  session_dir "/" t "/chat.request.yml" )
        cres_loadfromjsonfile( o, kp_i SUBSEP "\"cres\"",  session_dir "/" t "/chat.response.yml" )
    }
}

function chat_history_get_req_text(o, prefix, i){
    return o[ prefix SUBSEP "\""i"\"" SUBSEP "\"creq\"" SUBSEP "\"question\""]
}

function chat_history_get_res_text(o, prefix, i){
    return o[ prefix SUBSEP "\""i"\"" SUBSEP "\"cres\"" SUBSEP "\"reply\"" SUBSEP "\"content\"" ]
}

function chat_history_get_res_tool_call(o, prefix, i){
    return jstr0( o, prefix SUBSEP "\""i"\"" SUBSEP "\"cres\"" SUBSEP "\"reply\"" SUBSEP "\"tool_calls\"", " " )
}

function chat_history_get_finishReason(o, prefix, i){
    return o[ prefix SUBSEP "\""i"\"" SUBSEP "\"cres\"" SUBSEP "\"finishReason\"" ]
}

function chat_history_get_maxnum(o, prefix){
    return o[ prefix L ]
}

# provider: openai, gemini, chat
function chat_history_get_last_chatid(session_dir, provider, cur_chatid,            _cmd, t, last_chatid){
    _cmd = "{ command find " qu1(session_dir) " -name \""provider".response.yml\"" " | command sort -r; } 2>/dev/null"
    while( ( _cmd | getline t ) > 0 ){
        match(t, "/[^/]+/" provider ".response.yml")
        t = substr(t, RSTART+1)
        gsub("/.*$", "", t)
        if ( t == cur_chatid) continue
        last_chatid = t
        break
    }
    close( _cmd )
    if ( last_chatid  == "" ) return
    return last_chatid
}

function chat_history_get_last_creq(o, prefix, session_dir, provider, cur_chatid, last_chatid){
    if ( last_chatid == "" ) last_chatid = chat_history_get_last_chatid(session_dir, provider, cur_chatid)
    if ( last_chatid == "" ) return
    creq_loadfromjsonfile( o, prefix, session_dir "/" last_chatid "/chat.request.yml" )
}
