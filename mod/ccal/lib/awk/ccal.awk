
BEGIN{

}

function ccal_util_is_jiaqi( m, d,  lm, ld ){
    return ( gongli_is_jiaqi( m, d ) || lunar_is_jiaqi( lm, ld ) )
}

BEGIN{
    wmap["日"] = 0
    wmap["一"] = 1
    wmap["二"] = 2
    wmap["三"] = 3
    wmap["四"] = 4
    wmap["五"] = 5
    wmap["六"] = 6
}



function ccal_add(  \
    date, lunar_date, lunar_daycount, lunar_jianchu, wd, bazi, jieqi, jieqi_next, holiday, xiuxi, related, yi, ji, \
    t, kp, arr,     lunar_mon, lunar_day  ) {


    ymd_parse( t, "", date )
    kp = ymd_kp( t, "" )

    ccal[ kp, "y" ] = ymd_y( t )
    ccal[ kp, "m" ] = ymd_m( t )
    ccal[ kp, "d" ] = ymd_d( t )

    ccal[ kp, "wd" ] = wmap[ wd ]

    # parse lunar date
    split(lunar_date, arr, "-")
    lunar_yea = ccal[ kp, "ly"    ]        = int(arr[1])
    lunar_mon = ccal[ kp, "lm"    ]        = arr[2]
    lunar_day = ccal[ kp, "ld"    ]        = int(arr[3])

    ccal[ kp, "ldaycount" ] = lunar_daycount

    lunar_day = ccal[ kp, "jieqi" ]        = jieqi
    lunar_day = ccal[ kp, "jieqi_next" ]   = jieqi_next

    # parse gz
    split( bazi, arr, " " )
    ccal[ kp, "ygz" ] = arr[1]
    ccal[ kp, "mgz" ] = arr[2]
    ccal[ kp, "dgz" ] = arr[3]

    ccal[ kp, "sx" ]        = lunar_get_shengxiao_zh( lunar_yea )
    ccal[ kp, "jianchu" ]   = lunar_jianchu
    ccal[ kp, "liuyao" ]    = lunar_liuyao(       lunar_mon,  lunar_day )

    ccal[ kp, "sns" ]   = lunar_sns(                      lunar_day,  ccal[ kp, "dgz" ] )
    ccal[ kp, "ygj" ]   = lunar_is_yangji(    lunar_mon,  lunar_day )

    ccal[ kp, "yi" ] = yi
    ccal[ kp, "ji" ] = ji


    ccal[ kp, "xiuxi" ] = xiuxi

    ccal[ kp, "holiday_gongli" ] = get_gongli_holiday_zh( ccal[ kp, "m" ], ccal[ kp, "d" ], ccal[ kp, "wd" ] )

    return kp
}

function ccal_y(        kp ) {       return ccal[ kp, "y" ];     }
function ccal_m(        kp ) {       return ccal[ kp, "m" ];     }
function ccal_d(        kp ) {       return ccal[ kp, "d" ];     }
function ccal_wd(       kp ) {       return ccal[ kp, "wd" ];     }

function ccal_ly(       kp ) {       return ccal[ kp, "ly" ];    }
function ccal_lm(       kp ) {       return ccal[ kp, "lm" ];    }
function ccal_ld(       kp ) {       return ccal[ kp, "ld" ];    }

function ccal_ldaycount(   kp ) {       return ccal[ kp, "ldaycount" ];    }

function ccal_jieqi(       kp ) {       return ccal[ kp, "jieqi" ];    }
function ccal_jieqi_next(       kp ) {  return ccal[ kp, "jieqi_next" ];    }

function ccal_ygz(      kp ) {       return ccal[ kp, "ygz" ];    }
function ccal_mgz(      kp ) {       return ccal[ kp, "mgz" ];    }
function ccal_dgz(      kp ) {       return ccal[ kp, "dgz" ];    }

function ccal_jianchu(  kp ) {       return ccal[ kp, "jianchu" ];   }
function ccal_liuyao(   kp ) {       return ccal[ kp, "liuyao" ];    }

function ccal_sns(      kp ) {       return ccal[ kp, "sns" ];    }
function ccal_ygj(      kp ) {       return ccal[ kp, "ygj" ];    }

function ccal_yi(       kp ) {       return ccal[ kp, "yi" ];    }
function ccal_ji(       kp ) {       return ccal[ kp, "ji" ];    }


function ccal_xiuxi(    kp ) {       return ccal[ kp, "xiuxi" ];    }

function ccal_holiday_gongli(       kp ) {       return ccal[ kp, "holiday_gongli" ];    }

function ccal_is_jiaqi( kp ) {
    return ccal_util_is_jiaqi( ccal_m( kp ), ccal_d( kp ),  ccal_lm( kp ), ccal_ld( kp ) )
}

function ccal_is_weekend( kp,       wd ){
    wd = ccal_wd( kp )
    return ( (wd == 0) || (wd == 6) )
}
