
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
    source rollarch
    run rollarch_repos
    OUT="$(cat $ROLLARCH_MIRRORLIST)
"
    rm -f $ROLLARCH_MIRRORLIST
    OUT+="$(cat $PACMANCONF)
"
    rm -f $PACMANCONF
    [ -e $localdots ]
    OUT+="$(cat $localdots)
"
    #echo "$OUT" >&3
    rm -rf tmp.*

    [[ "$OUT" == "Server = http://192.168.1.108:8080
[ffy00]
Server = https://pkgbuild.com/~ffy00/repo
[dvzrv]
Server = https://pkgbuild.com/~dvzrv/repo/\$arch
[custom]
SigLevel = Optional TrustAll
Server = http://192.168.1.108:8080
#PKG: A
#PKG: B
#REPO: ffy00
#REPO: dvzrv
" ]]
}

