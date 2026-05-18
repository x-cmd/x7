
function time_cal_offset(){
    o0 = ENVIRON[ "___X_CMD_TIME_OFFSET0" ]
    o1 = ENVIRON[ "___X_CMD_TIME_OFFSET1" ]
    o2 = ENVIRON[ "___X_CMD_TIME_OFFSET2" ]

    if (o1 > o0) {
        return o2 - (o1 - o0)
    } else {
        return o2
    }
}

BEGIN{
    getline
    begin = $0

    CALIBRATION_OFFSET = time_cal_offset()
}

{
    time[ count ++ ] = $0
}

END{
    if (count < 1) {
        print "count:", count
        exit
    }

    for (i = 0; i < count; i++) {
        if (i == 0) {
            diff[i] = (time[i] - begin) * 1000
        } else {
            diff[i] = (time[i] - time[i-1]) * 1000
        }
    }

    for (i = 0; i < count; i++) {
        diff[i] = diff[i] - CALIBRATION_OFFSET
        if (diff[i] < 0) diff[i] = 0
    }

    if (batch != "") {
        for (i = 0; i < count; i++) {
            diff[i] = diff[i] / batch
        }
    }

    # Sort to find min/max/median
    for (i = 0; i < count; i++) {
        for (j = i + 1; j < count; j++) {
            if (diff[i] > diff[j]) {
                tmp = diff[i]; diff[i] = diff[j]; diff[j] = tmp
            }
        }
    }

    sum = 0
    for (i = 0; i < count; i++) {
        sum += diff[i]
    }
    avg = sum / count

    # Standard deviation
    sqsum = 0
    for (i = 0; i < count; i++) {
        sqsum += (diff[i] - avg) * (diff[i] - avg)
    }
    stddev = sqrt(sqsum / count)

    min = diff[0]
    max = diff[count-1]
    median = (count % 2 == 1) ? diff[int(count/2)] : (diff[count/2-1] + diff[count/2]) / 2

    if (output == "avg") {
        printf "%.3f\n", avg
    } else {
        printf "count:   %d\n", count
        printf "total:   %.3f ms\n", sum
        printf "offset:  %.3f ms\n", CALIBRATION_OFFSET
        printf "min:     %.3f ms\n", min
        printf "max:     %.3f ms\n", max
        printf "avg:     %.3f ms\n", avg
        printf "median:  %.3f ms\n", median
        printf "stddev:  %.3f ms\n", stddev
    }
}