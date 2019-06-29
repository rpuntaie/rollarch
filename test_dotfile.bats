
#13
@test "add PKG and REPO" {
    tmpdots=$(mktemp)
    echo "#PKG: A
#PKG: B
#REPO: ffy00
#REPO: dvzrv">$tmpdots
    export DOTS="file://$tmpdots"
    local localdots=${DOTS##*/}
    export PACMANCONF=$(mktemp)
    export ROLLARCH_MIRRORLIST=$(mktemp)
    export AIP2=1.108
    export MNT_PNT=mnt
    mkdir -p $MNT_PNT
    source rollarch
    run rollarch_repos
    OUT="$(cat $ROLLARCH_MIRRORLIST)"
    rm -f $ROLLARCH_MIRRORLIST
    OUT+="$(cat $PACMANCONF)"
    rm -f $PACMANCONF
    [ -e $MNT_PNT/$localdots ]
    OUT+="$(cat $MNT_PNT/$localdots)"
    rm -rf $MNT_PNT

    [[ "$OUT" == "Server=https://arch.scrumplex.net/\$repo/os/x86_64
Server=https://pkgbuild.com/~dvzrv/repo/\$arch
Server = http://192.168.1.108:8080[ungoo]
Server = https://arch.scrumplex.net/\$repo/os/x86_64
[dvzrv]
Server = https://pkgbuild.com/~dvzrv/repo/\$arch
[custom]
SigLevel = Optional TrustAll
Server = http://192.168.1.108:8080#PKG: A
#PKG: B
#REPO: ffy00
#REPO: dvzrv" ]]
}
