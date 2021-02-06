#!/usr/bin/env bats

@test "test user repos" {
    . ./rollarch
    repos="arcanisrepo dvzrv eschwartz herecura quarry seblu xyne-x86_64"
    for repo in $repos; do
        arch=x86_64
        repoconf=$(echo "$rollarch_additional_repo_names_possible" | sed -n -e "/^\[$repo\]/{N;p}")
        if [[ -n $repoconf ]]; then
            # echo "repo conf $repoconf" >&3
            reposrv=${repoconf/\[$repo\]/}
            reposrv=${reposrv//[[:space:]]/}
            reposrv=$(eval echo "${reposrv/Server=/}")
            # echo "repo $reposrv" >&3
            curl -Ls $reposrv | grep "pkg.tar.zst" &> /dev/null
            [ $? ]
        else
            echo "removed $repo" >&3
        fi
    done
}
