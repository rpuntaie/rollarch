mock(){
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
  function mkdir() { echo "$*"; }
  export -f mkdir
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
  function check_mnt_bash() { return 0; }
  export -f check_mnt_bash
  function arch-chroot() { echo "$4"; }
  export -f arch-chroot
  export PACMAN_MIRROR_LIST=$(mktemp)
  export MNT_ETC_FSTAB=$(mktemp)
  export MNT_ETC_PACMAN_CONF=$(mktemp)
}
export -f mock


