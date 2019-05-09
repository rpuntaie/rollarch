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

@test "no DISK" {
    skip
    mock
    run ./rollarch
    [ "$status" -eq 1 ]
    [ $(echo "$output" | sed "s/\(Fatal\): DISK.*/\1/g") = "Fatal" ]
}

@test "no USR" {
    skip
    mock
    DISK=x run ./rollarch
    [ "$status" -eq 1 ]
    [ $(echo "$output" | sed "s/\(Fatal\): USR.*/\1/g") = "Fatal" ]
}

@test "no PW" {
    skip
    mock
    DISK=x USR=y run ./rollarch
    [ "$status" -eq 1 ]
    [ $(echo "$output" | sed "s/\(Fatal\): PW.*/\1/g") = "Fatal" ]
}

@test "no PCNAME" {
    skip
    mock
    DISK=x USR=y PW=z run ./rollarch
    [ "$status" -eq 1 ]
    [ $(echo "$output" | sed "s/\(Fatal\): PCNAME.*/\1/g") = "Fatal" ]
}


@test "no ZONE" {
    skip
    mock
    DISK=x USR=y PW=z PCNAME=u run ./rollarch
    [ "$status" -eq 1 ]
    [ $(echo "$output" | sed "s/\(Fatal\): ZONE.*/\1/g") = "Fatal" ]
}

@test "no IP2" {
    skip
    mock
    DISK=x USR=y PW=z PCNAME=u ZONE=v run ./rollarch
    [ "$status" -eq 1 ]
    [ $(echo "$output" | sed "s/\(Fatal\): IP2.*/\1/g") = "Fatal" ]
}


@test "DISK wrong" {
    skip
    mock
    DISK=x USR=y PW=z PCNAME=u ZONE=v IP2=w run ./rollarch
    [ "$status" -eq 1 ]
    [ $(echo "$output" | sed "s/\(Fatal\): DISK wrong/\1/g") = "Fatal" ]
}


@test "USR wrong" {
    skip
    mock
    DISK=/dev/null USR='x y' PW=z PCNAME=u ZONE=v IP2=w run ./rollarch
    [ "$status" -eq 1 ]
    [ $(echo "$output" | sed "s/\(Fatal\): USR wrong/\1/g") = "Fatal" ]
}

@test "ZONE wrong" {
    skip
    mock
    DISK=/dev/null USR=y PW=z PCNAME=u ZONE=sdfhsv IP2=w run ./rollarch
    [ "$status" -eq 1 ]
    [ $(echo "$output" | sed "s/\(Fatal\): ZONE wrong/\1/g") = "Fatal" ]
}


@test "IP2 wrong" {
    skip
    mock
    DISK=/dev/null USR=y PW=z PCNAME=u ZONE=Berlin IP2=w run ./rollarch
    [ "$status" -eq 1 ]
    [ $(echo "$output" | sed "s/\(Fatal\): IP2 wrong/\1/g") = "Fatal" ]
}


@test "LA_NG wrong" {
    skip
    mock
    DISK=/dev/null USR=y PW=z PCNAME=u ZONE=Berlin IP2=1.106 LA_NG=ru run ./rollarch
    [ "$status" -eq 1 ]
    [ $(echo "$output" | sed "s/.*LA_NG \(wrong\)/\1/g") = "wrong" ]
}


@test "Pacman update" {
    skip
    mock
    DISK=/dev/null USR=y PW=z PCNAME=u ZONE=Berlin IP2=1.106 LA_NG=ru_RU run ./rollarch
    [ "$status" -eq 0 ]
    [ "${lines[0]}" = "-Sy" ]
    [ "${lines[1]}" = "--init" ]
    [ "${lines[2]}" = "--populate archlinux" ]
}

@test "VERBOSE on" {
    skip
    mock
    DISK=/dev/null USR=y PW=z PCNAME=u ZONE=Berlin IP2=1.106 LA_NG=ru_RU VERBOSE=on run ./rollarch
    [ "$status" -eq 0 ]
    [ $(echo "${lines[0]}" | sed "s/.*\(install\).*/\1/g") = "install" ]
    [ "${lines[1]}" = "-Sy" ]
    [ "${lines[2]}" = "--init" ]
    [ "${lines[3]}" = "--populate archlinux" ]
    [ "${lines[4]}" = "/dev/null" ]
    [ "${lines[7]}" = "  boot: /dev/null1" ]
    [ "${lines[8]}" = "  root: /dev/null2" ]
}


@test "SWAP on" {
    skip
    mock
    DISK=/dev/null USR=y PW=z PCNAME=u ZONE=Berlin IP2=1.106 VERBOSE=on SWAP=on run ./rollarch
    [ "$status" -eq 0 ]
    [ $(echo "${lines[0]}" | sed "s/.*\(install\).*/\1/g") = "install" ]
    [ "${lines[1]}" = "-Sy" ]
    [ "${lines[2]}" = "--init" ]
    [ "${lines[3]}" = "--populate archlinux" ]
    [ "${lines[4]}" = "/dev/null" ]
    [ "${lines[7]}" = "  boot: /dev/null1" ]
    [ "${lines[8]}" = "  swap: /dev/null2" ]
    [ "${lines[9]}" = "  root: /dev/null3" ]
}


@test "CHROOT preparation" {
    mock
    DISK=/dev/null USR=y PW=z PCNAME=u ZONE=Berlin IP2=1.106 VERBOSE=on SWAP=on run ./rollarch
    [ "$status" -eq 0 ]
    run tree rollarch.env
    [ "${lines[0]}" = "rollarch.env" ]
    [ "${lines[1]:1:7}" = "── boot" ]
}


#@test "test CHROOT script" {
#    mock
#    run rollarch.env/rollarch.sh
#    [ "$status" -eq 0 ]
#    #rm -rf rollarch.env
#}
