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
        rm -f etcsystemdresolvedconf
        rm -f etchosts
        rm -f etchostname
        rm -rf loader
        rm -f loadmodulecifs
    fi
}

#1
@test "show help" {
    run bash ./rollarchroot -h
    #echo "#${lines[1]}" >&3
    [ "${lines[1]}" = "DSK USR PW HST ZONE IP2 AIP2 BOOT SWAP ROOT KM" ]
    [ "$status" -eq 0 ]
}


#2
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
    KM=KM\
    run source rollarchroot
    #echo "#${lines[1]}" >&3
    [ "$status" -eq 0 ]
}

#3
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
    KM=KM\
    source rollarchroot
    run setup_arch_proxy
    [ "$status" -eq 0 ]
    [ -e ArchProxy.service ]
}

#4
@test "setup time" {
    function timedatectl() { echo "$*"; }
    export -f timedatectl
    function hwclock() { echo "$*"; }
    export -f hwclock
    export ZONE=Vienna
    export SYSTEMTIMECONF="mocktimesyncd"
    export LOCALTIMECONF="mocklocaltime"
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
    KM=KM\
    source rollarchroot
    run setup_time
    [ -e mocklocaltime ]
    [ -e mocktimesyncd ]
}


#5
@test "setup locale" {
    function sed() { echo "$*"; }
    export -f sed
    function locale-gen() { echo "$*"; }
    export -f locale-gen
    function locale() { echo "$*"; }
    export -f locale
    export LOCALEGEN="mocklocalegen"
    export LA_NG="it_IT de_DE"
    export LOCALEGEN="mocklocalegen"
    export LOCALECONF="mocklocaleconf"
    touch $LOCALEGEN
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
    KM=KM\
    source rollarchroot
    run setup_locale
    #echo "#${lines[0]}" >&3
    [[ "${lines[1]}" =~ "it_IT" ]]
    [[ "${lines[2]}" =~ "de_DE" ]]
    [[ "${lines[3]}" =~ "en_US" ]]
    [[ -f mocklocalegen ]]
    [[ -f mocklocaleconf ]]
}


#6
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
    KM=KM\
    source rollarchroot
    KM="US"
    run setup_keyboard
    #echo "#${lines[0]}" >&3
    [ "${lines[0]}" = "us.map.gz rollarchus.map.gz" ]
    [ "${lines[1]}" = "rollarchus" ]
}

#7
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
    export LOADMODULECIFS="loadmodulecifs"
    export VARLIBSAMBAUSERSHARES="varlibsambausershares"
    export ETCSAMBASMB="etcsambasmb"
    export ETCSYSTEMDNETWORKWIRED="etcsystemdnetworkwired"
    export ETCSYSTEMDNETWORKWIRELESS="etcsystemdnetworkwireless"
    export ETCSYSTEMDRESOLVEDCONF="etcsystemdresolvedconf"
    export ETCHOSTS="etchosts"
    export ETCHOSTNAME="etchostname"
    export HST="mockhst"
    export IP2="1.108"
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
    KM=KM\
    source rollarchroot
    run setup_network
    [ -e etchostname ]
    [ -e etchosts ]
    [ -e etcsystemdnetworkwired ]
    [ -e etcsystemdnetworkwireless ]
    [ -e etcsambasmb ]
    [ -e loadmodulecifs ]
}

#8
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
    export LOADMODULECIFS="loadmodulecifs"
    export VARLIBSAMBAUSERSHARES="varlibsambausershares"
    export ETCSAMBASMB="etcsambasmb"
    export ETCSYSTEMDNETWORKWIRED="etcsystemdnetworkwired"
    export ETCSYSTEMDNETWORKWIRELESS="etcsystemdnetworkwireless"
    export ETCSYSTEMDRESOLVEDCONF="etcsystemdresolvedconf"
    export ETCHOSTS="etchosts"
    export ETCHOSTNAME="etchostname"
    export HST="mockhst"
    export IP2="dhcp"
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
    KM=KM\
    source rollarchroot
    run setup_network
    [ -e etchostname ]
    [ -e etchosts ]
    [ -e etcsystemdnetworkwired ]
    [ -e etcsystemdnetworkwireless ]
    [ -e etcsambasmb ]
    [ -e etchostname ]
    [ -e loadmodulecifs ]
}

#9
@test "setup boot BIOS" {
    function grep() { echo GenuineIntel; }
    export -f grep
    function sed() { echo "$*"; }
    export -f sed
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
    KM=KM\
    source rollarchroot
    EFI=off
    run setup_boot
    #echo "#${lines[1]}" >&3
    [ "${lines[1]}" = "--target=i386-pc --recheck" ]
}

#10
@test "setup boot EFI" {
    function grep() { echo AuthenticAMD; }
    export -f grep
    function sed() { echo "$*"; }
    export -f sed
    function pacman() { echo "$*"; }
    export -f pacman
    function mkinitcpio() { echo "$*"; }
    export -f mkinitcpio
    function bootctl() { echo "$*"; }
    export -f bootctl
    function blkid() { echo "$*"; }
    export -f blkid
    export LOADERENTRY="loader/entries/arch"
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
    KM=KM\
    source rollarchroot
    EFI=on
    run setup_boot
    #echo "#${lines[1]}" >&3
    [ "${lines[1]}" = "-S --needed --noconfirm efibootmgr efitools" ]
    [ -e loader ]
}
