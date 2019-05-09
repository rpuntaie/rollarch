mock(){
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
  function dd() { echo "$*"; }
  export -f dd
  function parted() { echo "$*"; }
  export -f parted
  function umount() { echo "$*"; }
  export -f umount
  function mount() { echo "$*"; }
  export -f mount
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
  function arch-chroot() { cp rollarch.env/rollarch rollarch.env/rollarch.sh; }
  export -f arch-chroot
}
export -f mock


