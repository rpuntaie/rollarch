#!/usr/bin/env bats

@test "test user repos" {
    . ./rollarch
    repos="arcanisrepo dvzrv eschwartz herecura quarry seblu xyne-x86_64"
    rollarch_additional_repo_names_possible="
[arcanisrepo]
Server = https://repo.arcanis.me/repo/\$arch
[dvzrv]
Server = https://pkgbuild.com/~dvzrv/repo/\$arch
[eschwartz]
Server = https://pkgbuild.com/~eschwartz/repo/\$arch
[herecura]
Server = https://repo.herecura.be/\$repo/\$arch
[quarry]
Server = https://pkgbuild.com/~anatolik/quarry/x86_64/
[blackeagle-pre-community]
Server = https://repo.herecura.be/\$repo/\$arch
[seblu]
Server = https://al.seblu.net/\$repo/\$arch
[xyne-x86_64]
Server = https://xyne.archlinux.ca/repos/xyne
"
    for repo in $repos; do
        arch=x86_64
        repoconf=$(echo "$rollarch_additional_repo_names_possible" | sed -n -e "/^\[$repo\]/{N;p}")
        if [[ -n $repoconf ]]; then
            # echo "repo conf $repoconf" >&3
            reposrv=${repoconf/\[$repo\]/}
            reposrv=${reposrv//[[:space:]]/}
            reposrv=$(eval echo "${reposrv/Server=/}")
            echo "repo $reposrv" >&3
            curl -Ls $reposrv | grep "pkg.tar" &> /dev/null
            [ $? ]
        else
            echo "removed $repo" >&3
        fi
    done
}
