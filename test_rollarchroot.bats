#!/usr/bin/env bats

# setup for test:
# pacman -S bash-bats
#
# run with:
# bats --tap test_rollarchroot.bats

run_only_test() {
    if [ "$BATS_TEST_NUMBER" -ne "$1" ]; then
        skip
    fi
}

#setup()
#{
#    #run_only_test 1
#    #mock
#    function find() { echo "$*"; }
#    export -f find
#    function rm() { echo "$*"; }
#    export -f rm
#    function ln() { echo "$*"; }
#    export -f ln
#    function pacman() { echo "$*"; }
#    export -f pacman
#    function mv() { echo "$*"; }
#    export -f mv
#    function cd() { echo "$*"; }
#    export -f cd
#    function cat() { echo "$*"; }
#    export -f cat
#    function chmod() { echo "$*"; }
#    export -f chmod
#    function systemctl() { echo "$*"; }
#    export -f systemctl
#}

teardown()
{
    if [ -z "$TEST_FUNCTION" ]
    then
        rm -f ArchProxy.service
        rm -f mocktimesyncd.conf
        rm -f mocklocaltime
        rm -f mocktimesyncd
        rm -f mocklocalegen
        rm -f mocklocaleconf
        rm -f varlibsambausershares
        rm -f etcsambasmb
        rm -f etcsystemdnetworkwired
        rm -f etcsystemdnetworkwireless
        rm -f etcsystemdsystemnetworkservice
        rm -f etcsystemdresolvedconf
        rm -f etchosts
        rm -f etchostname
        rm -f archloaderconf
        rm -f loadmodulecifs
    fi
}

#1
@test "show help" {
    run ./rollarchroot -h
    [ "${lines[1]}" = "DSK USR PW HST LA_NG ZONE IP2 AIP2 BOOT SWAP ROOT UEFI KM" ]
    [ "$status" -eq 0 ]
}


#2
@test "missing define" {
    #DSK=DSK\
    USR=USR\
    PW=PW\
    HST=HST\
    LA_NG=LA_NG\
    ZONE=ZONE\
    IP2=IP2\
    AIP2=AIP2\
    BOOT=BOOT\
    SWAP=SWAP\
    ROOT=ROOT\
    UEFI=UEFI\
    KM=KM\
    run source rollarchroot
    #echo "#${lines[1]}" >&3
    [ "$status" -eq 1 ]
}

#3
@test "all define" {
    DSK=DSK\
    USR=USR\
    PW=PW\
    HST=HST\
    LA_NG=LA_NG\
    ZONE=ZONE\
    IP2=IP2\
    AIP2=AIP2\
    BOOT=BOOT\
    SWAP=SWAP\
    ROOT=ROOT\
    UEFI=UEFI\
    KM=KM\
    run source rollarchroot
    #echo "#${lines[1]}" >&3
    [ "$status" -eq 0 ]
}

#4
@test "setup arch proxy" {
    function cd() { echo "$*"; }
    export -f cd
    function ln() { echo "$*"; }
    export -f ln
    function cat() { echo "$*"; }
    export -f cat
    function systemctl() { echo "$*"; }
    export -f systemctl
    DSK=DSK\
    USR=USR\
    PW=PW\
    HST=HST\
    LA_NG=LA_NG\
    ZONE=ZONE\
    IP2=IP2\
    AIP2=AIP2\
    BOOT=BOOT\
    SWAP=SWAP\
    ROOT=ROOT\
    UEFI=UEFI\
    KM=KM\
    source rollarchroot
    run setup_arch_proxy
    [ "$status" -eq 0 ]
    [ -e ArchProxy.service ]
}

#5
@test "setup time" {
    function timedatectl() { echo "$*"; }
    export -f timedatectl
    function hwclock() { echo "$*"; }
    export -f hwclock
    DSK=DSK\
    USR=USR\
    PW=PW\
    HST=HST\
    LA_NG=LA_NG\
    ZONE=ZONE\
    IP2=IP2\
    AIP2=AIP2\
    BOOT=BOOT\
    SWAP=SWAP\
    ROOT=ROOT\
    UEFI=UEFI\
    KM=KM\
    source rollarchroot
    ZONE=Vienna
    SYSTEMTIMECONF="mocktimesyncd"
    LOCALTIMECONF="mocklocaltime"
    run setup_time
    [ -e mocklocaltime ]
    [ -e mocktimesyncd ]
}


#6
@test "setup locale" {
    function sed() { echo "$*"; }
    export -f sed
    function locale-gen() { echo "$*"; }
    export -f locale-gen
    function locale() { echo "$*"; }
    export -f locale
    DSK=DSK\
    USR=USR\
    PW=PW\
    HST=HST\
    LA_NG=LA_NG\
    ZONE=ZONE\
    IP2=IP2\
    AIP2=AIP2\
    BOOT=BOOT\
    SWAP=SWAP\
    ROOT=ROOT\
    UEFI=UEFI\
    KM=KM\
    source rollarchroot
    LA_NG="it_IT de_DE"
    LOCALEGEN="mocklocalegen"
    LOCALECONF="mocklocaleconf"
    touch $LOCALEGEN
    run setup_locale
    #echo "#${lines[0]}" >&3
    [[ "${lines[0]}" =~ "it_IT" ]]
    [[ "${lines[1]}" =~ "de_DE" ]]
    [[ "${lines[2]}" =~ "en_US" ]]
    [ -e mocklocalegen ]
    [ -e mocklocaleconf ]
}


#7
@test "setup escape" {
    function sed() { echo "$*"; }
    export -f sed
    function cp() { echo "$*"; }
    export -f cp
    function gunzip() { echo "$*"; }
    export -f gunzip
    function gzip() { echo "$*"; }
    export -f gzip
    function loadkeys() { echo "$*"; }
    export -f loadkeys
    function localectl() { echo "$*"; }
    export -f localectl
    DSK=DSK\
    USR=USR\
    PW=PW\
    HST=HST\
    LA_NG=LA_NG\
    ZONE=ZONE\
    IP2=IP2\
    AIP2=AIP2\
    BOOT=BOOT\
    SWAP=SWAP\
    ROOT=ROOT\
    UEFI=UEFI\
    KM=KM\
    source rollarchroot
    KM="US"
    run setup_escape
    #echo "#${lines[0]}" >&3
    [ "${lines[0]}" = "us rollarchus.map.gz" ]
    [ "${lines[4]}" = "rollarchus.map" ]
}

#8
@test "setup network IP" {
    function ip() { return 0; }
    export -f ip
    function grep() { return 0; }
    export -f grep
    function sed() { echo "enp0s3 wlp1s0"; }
    export -f sed
    function curl() { echo "$*"; }
    export -f curl
    function systemctl() { echo "$*"; }
    export -f systemctl
    function groupadd() { echo "$*"; }
    export -f groupadd
    function chown() { echo "$*"; }
    export -f chown
    function chmod() { echo "$*"; }
    export -f chmod
    function mkdir() { echo "$*"; }
    export -f mkdir
    DSK=DSK\
    USR=USR\
    PW=PW\
    HST=HST\
    LA_NG=LA_NG\
    ZONE=ZONE\
    IP2=IP2\
    AIP2=AIP2\
    BOOT=BOOT\
    SWAP=SWAP\
    ROOT=ROOT\
    UEFI=UEFI\
    KM=KM\
    source rollarchroot
    LOADMODULECIFS="loadmodulecifs"
    VARLIBSAMBAUSERSHARES="varlibsambausershares"
    ETCSAMBASMB="etcsambasmb"
    ETCSYSTEMDNETWORKWIRED="etcsystemdnetworkwired"
    ETCSYSTEMDNETWORKWIRELESS="etcsystemdnetworkwireless"
    ETCSYSTEMDSYSTEMNETWORKSERVICE="etcsystemdsystemnetworkservice"
    ETCSYSTEMDRESOLVEDCONF="etcsystemdresolvedconf"
    ETCHOSTS="etchosts"
    ETCHOSTNAME="etchostname"
    HST="mockhst"
    IP2="1.108"
    run setup_network
    [ -e etchostname ]
    [ -e etchosts ]
    [ -e etcsystemdsystemnetworkservice ]
    [ -e etcsystemdnetworkwired ]
    [ -e etcsystemdnetworkwireless ]
    [ -e etcsambasmb ]
    [ -e loadmodulecifs ]
}

@test "setup network DHCP" {
    function ip() { return 0; }
    export -f ip
    function grep() { return 0; }
    export -f grep
    function sed() { echo "enp0s3 wlp1s0"; }
    export -f sed
    function curl() { echo "$*"; }
    export -f curl
    function systemctl() { echo "$*"; }
    export -f systemctl
    function groupadd() { echo "$*"; }
    export -f groupadd
    function chown() { echo "$*"; }
    export -f chown
    function chmod() { echo "$*"; }
    export -f chmod
    function mkdir() { echo "$*"; }
    export -f mkdir
    DSK=DSK\
    USR=USR\
    PW=PW\
    HST=HST\
    LA_NG=LA_NG\
    ZONE=ZONE\
    IP2=IP2\
    AIP2=AIP2\
    BOOT=BOOT\
    SWAP=SWAP\
    ROOT=ROOT\
    UEFI=UEFI\
    KM=KM\
    source rollarchroot
    LOADMODULECIFS="loadmodulecifs"
    VARLIBSAMBAUSERSHARES="varlibsambausershares"
    ETCSAMBASMB="etcsambasmb"
    ETCSYSTEMDNETWORKWIRED="etcsystemdnetworkwired"
    ETCSYSTEMDNETWORKWIRELESS="etcsystemdnetworkwireless"
    ETCSYSTEMDSYSTEMNETWORKSERVICE="etcsystemdsystemnetworkservice"
    ETCSYSTEMDRESOLVEDCONF="etcsystemdresolvedconf"
    ETCHOSTS="etchosts"
    ETCHOSTNAME="etchostname"
    HST="mockhst"
    IP2="dhcp"
    run setup_network
    [ -e etchostname ]
    [ -e etchosts ]
    [ -e etcsystemdnetworkwired ]
    [ -e etcsystemdnetworkwireless ]
    [ -e etcsambasmb ]
    [ -e etchostname ]
    [ -e loadmodulecifs ]
}

@test "setup boot BIOS" {
    function grep() { echo GenuineIntel; }
    export -f grep
    function pacman() { echo "$*"; }
    export -f pacman
    function mkinitcpio() { echo "$*"; }
    export -f mkinitcpio
    function grub-install() { echo "$*"; }
    export -f grub-install
    function grub-mkconfig() { echo "$*"; }
    export -f grub-mkconfig
    DSK=DSK\
    USR=USR\
    PW=PW\
    HST=HST\
    LA_NG=LA_NG\
    ZONE=ZONE\
    IP2=IP2\
    AIP2=AIP2\
    BOOT=BOOT\
    SWAP=SWAP\
    ROOT=ROOT\
    UEFI=UEFI\
    KM=KM\
    source rollarchroot
    UEFI="off"
    run setup_boot
    [ "${lines[0]}" = "-p linux" ]
}

@test "setup boot UEFI" {
    function grep() { echo AuthenticAMD; }
    export -f grep
    function pacman() { echo "$*"; }
    export -f pacman
    function bootctl() { echo "$*"; }
    export -f bootctl
    function blkid() { echo "$*"; }
    export -f blkid
    DSK=DSK\
    USR=USR\
    PW=PW\
    HST=HST\
    LA_NG=LA_NG\
    ZONE=ZONE\
    IP2=IP2\
    AIP2=AIP2\
    BOOT=BOOT\
    SWAP=SWAP\
    ROOT=ROOT\
    UEFI=UEFI\
    KM=KM\
    source rollarchroot
    UEFI="on"
    ARCHLOADERCONF="archloaderconf"
    run setup_boot
    #echo "#${lines[0]}" >&3
    [ "${lines[0]}" = "--path=/boot install" ]
    [ -e archloaderconf ]
}
