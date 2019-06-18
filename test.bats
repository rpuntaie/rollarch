#!/usr/bin/env bats

# setup for test:
# pacman -S bash-bats
#
# run with:
# bats --tap test.bats

load test_helper

#setup()
#{
#    . ../../bash_shell_mock/bin/shellmock
#    skipIfNot "$BATS_TEST_DESCRIPTION"
#    shellmock_clean
#}

#teardown()
#{
#    if [ -z "$TEST_FUNCTION" ]
#    then
#        shellmock_clean
#    fi
#}

@test "no internet" {
    #shellmock_expect ping --status 1 --match '-c 1 -W 1 8.8.8.8'
    function ping() { return 1; }
    export -f ping
    run ./rollarch
    [ "$status" -eq 1 ]
    [ $(echo "$output" | sed "s/\(Fatal\): Internet.*/\1/g") = "Fatal" ]
    #shellmock_verify
    #[ "${capture[0]}" = 'ping-stub -c 1 -W 1 8.8.8.8' ]
}

@test "no DSK" {
    #skip
    mock
    run ./rollarch
    [ "$status" -eq 1 ]
    [ $(echo "$output" | sed "s/\(Fatal\): DSK.*/\1/g") = "Fatal" ]
}

@test "no USR" {
    #skip
    mock
    DSK=x run ./rollarch
    [ "$status" -eq 1 ]
    [ $(echo "$output" | sed "s/\(Fatal\): USR.*/\1/g") = "Fatal" ]
}

@test "no PW" {
    #skip
    mock
    DSK=x USR=y run ./rollarch
    [ "$status" -eq 1 ]
    [ $(echo "$output" | sed "s/\(Fatal\): PW.*/\1/g") = "Fatal" ]
}

@test "no HST" {
    #skip
    mock
    DSK=x USR=y PW=z run ./rollarch
    [ "$status" -eq 1 ]
    [ $(echo "$output" | sed "s/\(Fatal\): HST.*/\1/g") = "Fatal" ]
}


@test "no ZONE" {
    #skip
    mock
    DSK=x USR=y PW=z HST=u run ./rollarch
    [ "$status" -eq 1 ]
    [ $(echo "$output" | sed "s/\(Fatal\): ZONE.*/\1/g") = "Fatal" ]
}

@test "DSK wrong" {
    #skip
    mock
    DSK=x USR=y PW=z HST=u ZONE=v IP2=w run ./rollarch
    [ "$status" -eq 1 ]
    [ $(echo "$output" | sed "s/\(Fatal\): DSK wrong/\1/g") = "Fatal" ]
}

@test "USR wrong" {
    #skip
    mock
    DSK=/dev/null USR='x y' PW=z HST=u ZONE=v IP2=w run ./rollarch
    [ "$status" -eq 1 ]
    [ $(echo "$output" | sed "s/\(Fatal\): USR wrong/\1/g") = "Fatal" ]
}

@test "ZONE wrong" {
    #skip
    mock
    DSK=/dev/null USR=y PW=z HST=u ZONE=sdfhsv IP2=w run ./rollarch
    [ "$status" -eq 1 ]
    [ $(echo "$output" | sed "s/\(Fatal\): ZONE wrong/\1/g") = "Fatal" ]
}


@test "LA_NG wrong" {
    #skip
    mock
    DSK=/dev/null USR=y PW=z HST=u ZONE=Berlin IP2=1.106 LA_NG=ru run ./rollarch
    [ "$status" -eq 1 ]
    [ $(echo "$output" | sed "s/.*LA_NG \(wrong\)/\1/g") = "wrong" ]
}


@test "SWAP on" {
    #skip
    mock
    DSK=/dev/null USR=y PW=z HST=u ZONE=Berlin IP2=1.106 SWAP=on run ./rollarch
    #echo "#${lines[1]}" >&3
    [ "${lines[1]}" = "  boot: /dev/null1" ]
    [ "${lines[2]}" = "  swap: /dev/null2" ]
    [ "${lines[3]}" = "  root: /dev/null3" ]
}


@test "CHROOT preparation" {
    mock
    DSK=/dev/null USR=y PW=z HST=u ZONE=Berlin IP2=1.106 SWAP=on run ./rollarch
    #echo "#${lines[13]:0:4}" >&3
    [ "$status" -eq 0 ]
    [ "${lines[12]:0:4}" = "DSK=" ]
    [ "${lines[13]:0:4}" = "USR=" ]
}

