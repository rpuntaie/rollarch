#!/usr/bin/env bats

# setup for test:
# pacman -S bash-bats
#
# run with:
# bats --tap test_rollarch.bats

run_only_test() {
    if [ "$BATS_TEST_NUMBER" -ne "$1" ]; then
        skip
    fi
}

setup()
{
    #run_only_test 13
    #mock
    function curl() { return 0; }
    export -f curl
    function ping() { return 0; }
    export -f ping
    function ntpdate() { return 0; }
    export -f ntpdate
    function timedatectl() { return 0; }
    export -f timedatectl
    function pacman() { echo "$*"; }
    export -f pacman
    function pacman-db-upgrade() { echo "$*"; }
    export -f pacman-db-upgrade
    function pacman-key() { echo "$*"; }
    export -f pacman-key
    function rankmirrors() { return 0; }
    export -f rankmirrors
    function dd() { echo "$*"; }
    export -f dd
    function parted() { echo "$*"; }
    export -f parted
    function umount() { echo "$*"; }
    export -f umount
    function mount() { echo "$*"; }
    export -f mount
    function mv() { echo "$*"; }
    export -f mv
    function cat() { return 0; }
    export -f cat
    function chmod() { return 0; }
    export -f chmod
    function genfstab() { return 0; }
    export -f genfstab
    function mkfs() { echo "$*"; }
    export -f mkfs
    function pacstrap() { echo "$*"; }
    export -f pacstrap
    function ls() { echo "${1}1"; echo "${1}2"; echo "${1}3"; }
    export -f ls
    function mkswap() { read choice; echo "$*"; }
    export -f mkswap
    function tunefs() { read choice; echo "$*"; }
    export -f tunefs
    function arch-chroot() { echo "$4"; }
    export -f arch-chroot
    export ROLLARCH_MIRRORLIST=$(mktemp)
    export MNT_PNT=/tmp
    mkdir -p /tmp/usr/bin/bash
}

teardown()
{
    if [ -z "$TEST_FUNCTION" ]
    then
        #un_mock
        rm -rf /tmp/usr
        rm -rf /tmp/etc
        rm -rf /tmp/boot
    fi
}

#1
@test "no internet" {
    function ping() { return 1; }
    export -f ping
    PW=p run bash ./rollarch
    [ "$status" -eq 1 ]
    [ $(echo "$output" | sed "s/\(Fatal\): Internet.*/\1/g") = "Fatal" ]
}

#2
@test "no DSK" {
    PW=p run bash ./rollarch
    [ "$status" -eq 1 ]
    [ $(echo "$output" | sed "s/\(Fatal\): DSK.*/\1/g") = "Fatal" ]
}

#3
@test "no USR" {
    PW=p DSK=x run bash ./rollarch
    [ "$status" -eq 1 ]
    [ $(echo "$output" | sed "s/\(Fatal\): USR.*/\1/g") = "Fatal" ]
}


#4
@test "no HST" {
    DSK=x USR=y PW=z run bash ./rollarch
    [ "$status" -eq 1 ]
    [ $(echo "$output" | sed "s/\(Fatal\): HST.*/\1/g") = "Fatal" ]
}

#5
@test "no ZONE" {
    DSK=x USR=y PW=z HST=u run bash ./rollarch
    [ "$status" -eq 1 ]
    [ $(echo "$output" | sed "s/\(Fatal\): ZONE.*/\1/g") = "Fatal" ]
}

#6
@test "DSK wrong" {
    DSK=x USR=y PW=z HST=u ZONE=v IP2=w run bash ./rollarch
    [ "$status" -eq 1 ]
    [ $(echo "$output" | sed "s/\(Fatal\): DSK wrong/\1/g") = "Fatal" ]
}

#7
@test "USR wrong" {
    DSK=/dev/null USR='x y' PW=z HST=u ZONE=v IP2=w run bash ./rollarch
    [ "$status" -eq 1 ]
    [ $(echo "$output" | sed "s/\(Fatal\): USR wrong/\1/g") = "Fatal" ]
}

#8
@test "ZONE wrong" {
    DSK=/dev/null USR=y PW=z HST=u ZONE=sdfhsv IP2=w run bash ./rollarch
    [ "$status" -eq 1 ]
    [ $(echo "$output" | sed "s/\(Fatal\): ZONE wrong/\1/g") = "Fatal" ]
}

#9
@test "LA_NG wrong" {
    DSK=/dev/null USR=y PW=z HST=u ZONE=Berlin IP2=1.106 LA_NG=ru run bash ./rollarch
    [ "$status" -eq 1 ]
    [ $(echo "$output" | sed "s/.*LA_NG \(wrong\)/\1/g") = "wrong" ]
}

#10
@test "SWAP on" {
    DSK=/dev/null USR=y PW=z HST=u ZONE=Berlin IP2=1.106 SWAP=on EFI=off run bash ./rollarch
    [ "${lines[1]}" = "--script /dev/null mklabel msdos" ]
    DSK=/dev/null USR=y PW=z HST=u ZONE=Berlin IP2=1.106 SWAP=on EFI=on run bash ./rollarch
    [ "${lines[1]}" = "--script /dev/null mklabel gpt" ]
}

#11
@test "CHROOT preparation" {
    DSK=/dev/null USR=y PW=z HST=u ZONE=Berlin IP2=1.106 SWAP=on EFI=off run bash ./rollarch
    #echo "#${lines[8]}" >&3
    [ "$status" -eq 0 ]
    [ "${lines[11]:0:4}" = "DSK=" ]
    [ "${lines[12]:0:4}" = "USR=" ]
}


