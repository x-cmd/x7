BEGIN{
    mount_data = ENVIRON[ "mount_data" ]
    l = split(mount_data, arr, "\n")
    for (i = 1; i <= l; i++) {
        split(arr[i], _arr, " ")
        mount_attr[ _arr[3] ] = _arr[6]
    }
}

NR==1{
    OFS=","
    t = index($0, "Type")
    print $1, $2, $3, $4, $5, $6, $7, $8, $9, "Mounted_path", "Mounted_attr"
    next
}

{
    first = substr($0, 1, t-1)
    gsub("(^[ ]+)|[[ ]+$]", "", first)
    $0 = substr($0, t)

    attr = mount_attr[ $9 ]
    printf( "%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s\n",  first, $1, $2, $3, $4, $5, $6, $7, $8, $9, "\""attr"\"" )
}

