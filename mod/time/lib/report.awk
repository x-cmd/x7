BEGIN{
    getline
    begin = $0
}

{
    time[ count ++ ] = $0
}

END{
    if (count < 2) {
        print "count:", count
        exit
    }

    # Calculate differences from begin
    for (i = 0; i < count; i++) {
        diff[i] = (time[i] - begin) * 1000  # convert to ms
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

    printf "count:   %d\n", count
    printf "min:     %.3f ms\n", min
    printf "max:     %.3f ms\n", max
    printf "avg:     %.3f ms\n", avg
    printf "median:  %.3f ms\n", median
    printf "stddev: %.3f ms\n", stddev
}