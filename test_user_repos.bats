@test "test user repos" {
    . ./rollarch
    repos="arcanisrepo dvzrv eschwartz herecura quarry blackeagle-pre-community city ffy00 maximbaz seblu sergej-repo xyne-x86_64"
    for repo in $repos; do
        arch=x86_64
        repoconf=$(echo "$rollarch_additional_repo_names_possible" | sed -n -e "/^\[$repo\]/{N;p}")
        reposrv=${repoconf/\[$repo\]/}
        reposrv=${reposrv//[[:space:]]/}
        reposrv=$(eval echo "${reposrv/Server=/}")
        curl -Ls $reposrv | grep "pkg.tar.xz" &> /dev/null
        [ $? ]
    done
}
