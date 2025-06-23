BEGIN{
    FS = "\t"
}


# TODO: using an object for this.
function ccal_parse_all(){
    date            = $1 # like 1910-05-01	一
    lunar_date      = $2
    lunar_daycount  = $3

    # parse yea mon day from gongli date
    ymd_parse( o_gdate, "", date )
    day = ymd_d( o_gdate )
    datekp = ymd_kp( o_gdate )

    # parse yea mon day from lunar_date
    split(lunar_date, a, "-")
    ccal[ datekp, "ly"    ]        = lunar_yea = int(a[1])
    ccal[ datekp, "lm"    ]        = lunar_mon = a[2]
    ccal[ datekp, "ld"    ]        = lunar_day = int(a[3])

    lunar_wd        = $5
    wday = wmap[ lunar_wd ]

    ganzhi          = $6
    split( ganzhi, a, " ")

    ccal[ datekp, "nianganzhi" ]   = a[1]
    ccal[ datekp, "yueganzhi" ]    = a[2]
    ccal[ datekp, "ganzhi" ]       = a[3]

    lunar_jieqi             = $7
    lunar_jieqi_next        = $8

    ccal[ datekp, "yi"    ]        = $12
    ccal[ datekp, "ji"    ]        = $13
}

{
    # ccal_parse_all()
    datekp = ccal_add( $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13 )

    ccal[ datekp, "lm-zh"    ] = lunar_mon_zh = lunar_get_month_zh( ccal_lm( datekp ), ccal_ldaycount( datekp )  )
    ccal[ datekp, "ld-zh"    ] = lunar_day_zh = lunar_get_day_zh( ccal_ld( datekp ) )

    ccal[ datekp ] = lunar_day_zh

    xiuxi = ccal_xiuxi( datekp )
    if (ccal_is_jiaqi( datekp ) ) {
        ccal[ datekp, "x" ] = "\033[1;31m"
    } else if (xiuxi == "休") {
        ccal[ datekp, "x" ] = "\033[1;31m"
    } else if (xiuxi == "工") {
        ccal[ datekp, "x" ] = "\033[0m"
    } else if (ccal_is_weekend(datekp)) {
        ccal[ datekp, "x" ] = "\033[31m"
    } else {
        ccal[ datekp, "x" ] = "\033[0m"
    }

    gongli_holiday = ccal_holiday_gongli( datekp )

    lunar_jieqi = ccal_jieqi( datekp )

    if (lunar_jieqi != "无") {
        ccal[ datekp ] = "\033[0;31m" lunar_jieqi       " " "\033[0m" "  "
    } else if ( gongli_holiday != "" ) {
        ccal[ datekp ] = "\033[0;31m" gongli_holiday    " " "\033[0m" "  "
    } else if (lunar_day_zh == "初一") {
        if ( ccal_ldaycount( datekp ) == 30) {
            ccal[ datekp ] = "\033[0;31;1m" lunar_mon_zh " "
        } else {
            ccal[ datekp ] = "\033[0;31;2m" lunar_mon_zh " "
        }
    } else {
        ccal[ datekp ] =  ccal[ datekp ]                        " " "\033[0m" "  "
    }

    lastkp = datekp
    lastday = ccal_d( datekp )
}

BEGIN{
    ymd_parse( TODAY, "", today )
    ymd_parse( HLDAY, "", ( hlday = ENVIRON["HLDAY"] ) )
}

function draw_lunar(){
    SP = " " "\033[0m" "  "

    LEADING = "  "

    printf("\n")

    printf(LEADING "\033[1;4m" "                " "\033[1m" "%04d %s年 " "%02d 月"  "               " "\033[0m" SP, ymd_y( o_gdate ),  ani , ymd_m( o_gdate ))

    printf("\n\n")


    printf(LEADING "\033[31m" "%s" SP,  gongli_wd_name( 0, WD_STYLE_CODE ))
    printf("%s" SP,                     gongli_wd_name( 1, WD_STYLE_CODE ))
    printf("%s" SP,                     gongli_wd_name( 2, WD_STYLE_CODE ))
    printf("%s" SP,                     gongli_wd_name( 3, WD_STYLE_CODE ))
    printf("%s" SP,                     gongli_wd_name( 4, WD_STYLE_CODE ))
    printf("%s" SP,                     gongli_wd_name( 5, WD_STYLE_CODE ))
    printf("\033[31m" "%s" SP,          gongli_wd_name( 6, WD_STYLE_CODE ))
    printf("\n\n")

    ym_kp = ymd_kp_ym( o_gdate )

    space = ccal_wd( ym_kp SUBSEP 1 )
    line0 = ""
    for (i=1; i<=space; ++i) {
        line0 = line0 ("    " SP)
    }

    line1 = LEADING line0
    line2 = LEADING line0


    for (i=1; i<=lastday; ++i) {
        w = ccal_wd( ym_kp SUBSEP i )
        line1 = line1 "\033[0m"
        line2 = line2 "\033[0m"

        if ( ymd_eqymd( TODAY, "",      ymd_y( o_gdate ), ymd_m( o_gdate ), i ) ) {
            line1 = line1 "\033[7;1m"
            line2 = line2 "\033[7;1m"
        }

        if ( ymd_eqymd( HLDAY, "",   ymd_y( o_gdate ), ymd_m( o_gdate ), i ) ) {
            line1 = line1 "\033[46;1m"
            line2 = line2 "\033[46;1m"
        }

        line1 = line1 sprintf(ccal[ ym_kp, i, "x" ] "%3d " SP, i)
        line2 = line2 sprintf("\033[2m" "%s", ccal[ ym_kp, i ])

        if (w == 6) {
            if (i != lastday) {
                printf("%s\n%s\n", line1, line2)
                line1 = LEADING
                line2 = LEADING
            }
        }
    }

    printf("%s\n%s\n", line1, line2)
    printf("\033[0m\n")
}

function draw_lunar_info( _d, kp, o ){

    ym_kp = ymd_kp_ym( o_gdate )

    if ( hlday == "" ) {
        if ( ! ymd_is_same_month( TODAY, "", o_gdate, "" ) ) return
        _d = ymd_d( TODAY )
    } else {
        _d = ymd_d( HLDAY )
    }

    kp = ym_kp SUBSEP _d

    o = ccal[ ym_kp, _d, "lm-zh"    ]
    gsub("(^[ ]+)|([ ]+$)", "", o)

    printf("  %s %-8s %-10s %-10s\n", "[轩辕]", lunar_xuanyuan( ccal_ly( kp ) ) "年", o, ccal[ ym_kp, _d, "ld-zh"    ] )

    o = ccal_mgz( kp )
    gsub("(^[ ]+)|([ ]+$)", "", o)

    printf("  %s %-8s %-10s %-10s\n",  "[干支]", ccal_ygz( kp ) "年",  o "月", ccal_dgz( kp ) "日"  )

    printf("\033[36m" "  [%s] %s" "\033[0m\n", "值星", ccal_jianchu( kp ) "日" )

    printf("\033[36m" "  [%s] %s" "\033[0m\n", "六曜", ccal_liuyao( kp ) )


    o = ""
    if (ccal_sns( kp )) {
        o = sprintf("\033[0;7m" "%s" "\033[0m ", "三娘煞")
    }
    if (ccal_ygj( kp )) {
        o = o sprintf("\033[0;7m" "%s" "\033[0m ", "杨公忌")
    }
    if ( o != "") {
        printf("  [%s] %s\n", "俗忌", o)
    } else {
        printf("\n")
    }
    printf("\033[0m\n")

    printf("\033[31m" "  [%s] %s\n", "宜", ccal_yi( kp ))
    printf("\033[0m\n")
    printf("\033[32m" "  [%s] %s\n", "忌", ccal_ji( kp ))
    printf("\033[0m\n\n")
}

END{
    ymd_new( o_gdate, "",   ccal_y( lastkp ), ccal_m( lastkp ), ccal_d( lastkp ) )
    draw_lunar()
    draw_lunar_info()
}

