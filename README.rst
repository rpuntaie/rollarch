********
Rollarch
********

Purpose
=======

Automates ArchLinux installation using

- dotfiles install script and offering
- custom packages

All parameters are provided at call time,
as an automation should not bombard you with questions.

Look into `rollarch`_ to see what is done during installation.

Usage
=====

Make a boot media. Here an USB memory stick:

.. code:: sh

  lsblk # verify that sdg is the usb memory stick
  sudo dd bs=4M if=/home/roland/myd/sw/linux/archlinux-2022.10.01-x86_64.iso of=/dev/sdg conv=fsync oflag=direct status=progress
  # the archlinux iso should be new, else problems with keys

For wireless-only devices you will need to connect to an access point manually at the ``archiso`` prompt:

.. code:: sh

    iwctl
    > device list
    > station wlan0 scan
    > station wlan0 get-networks
    > station wlan0 connect TP-LINK_C25554
    > quit

Then

.. code:: sh

    curl -OLs https://git.io/installarch #inspect, modify
    DSK=/dev/sda USR=u PW=p HST=u106 IP2=1.106 ZONE=Berlin bash installarch

``https://git.io/installarch`` is short for
``https://raw.githubusercontent.com/rpuntaie/rollarch/master/rollarch``.

Alternatively you can clone `rollarch`_ to another LAN box (e.g. 1.108) and add the path to NFS

/etc/exports::

   # Use `exportfs -arv` to reload.
   /path/to/rollarch	    192.168.1.0/24(rw,sync,subtree_check)

Then at the ``archiso`` prompt:

.. code:: sh

    mkdir rollarch
    mount -t nfs 192.168.1.108:</path/to/rollarch> rollarch
    cd rollarch
    DSK=/dev/sda USR=u PW=p HST=u106 IP2=1.106 ZONE=Berlin DOTS=mydots bash rollarch

If ``mydots`` is a dots install script available locally,
``https://git.io/mydots`` is not tried.
Here an `example <https://git.io/fjVcp>`__ for a ``mydots`` script.

.. code:: sh

   # notebook with just WLAN, no ethernet
   SSID=x WK=y WIP2=1.111 USR=u PW=p HST=u111 DSK=/dev/nvme0n1 SWAP=off ZONE=Vienna DOTS=fjVcp bash installarch

Without further arguments after ``rollarch`` (=``installarch``), the packages default to
``arch-install-scripts base base-devel devtools dialog wpa_supplicant ntp nfs-utils samba sudo git python vim zsh``.

For systems supporting UEFI
`systemd-boot <https://wiki.archlinux.org/index.php/Systemd-boot>`_ is used,
else `grub <https://wiki.archlinux.org/index.php/GRUB>`_.
`systemd-init <https://wiki.archlinux.org/index.php/Mkinitcpio>`_ is not used.

Parameters
----------

:DSK: disk on which to install (not partition)

:USR: main user of the system

:PW: password of main user (will ask if omitted)

:HST: host name of the system

:ZONE: a city name ending that can be found in ``/usr/shar/zoneinfo``

Optional:

:SWAP: [on|off] (on), set to 'off' e.g. for SSD and if you don't need swap

:LVM: [e.g. /dev/sdb], disks additional to $ROOT to form new LVM $ROOT /dev/vg0/lv0
      Use dummy if only the root partition of $DSK should become LVM.

:IP2: (192.168.)x.y, [e.g. 1.106], else dhcp

:AIP2: [e.g. 1.199 | yes, to create Arch Proxy].
       The x.y of another arch linux machine (the `local proxy`_)

:DOTS: Full URL or ``https://git.io/SHORT`` to a bash installation script for dot files.
       It can provide defines, packages and repos via ``#DFN:``, ``#PKG:`` and ``#REPO:`` comments.

:LA_NG: Space separated list of xx_YY used in addition to en_US [e.g. "de_DE ru_RU"]
        Don't include ``en_US``.

:KM: (us) one of ``localectl list-keymaps``.

:CL: If given, Escape is mapped to Caps_Lock and Caps_Lock to this key for VConsole.
     99 is [Print], 125 is [Win] aka Super_L.
     For X, execute these either through ``~/.Xmodmap`` or directly with ``xmodmap -e``::

        clear Lock
        keycode 0x42 = Escape
        keysym Print = Caps_Lock

:WIP2: for static IP2 and separate wl NIC, else bonding en+wl with IP2

:SSID: name of WLAN access point

:WK: password of WLAN access point

The ``AIP2`` and ``DOTS`` defines are very useful and will be addressed below.

Status
======

Tested for VirtualBox (EFI and BIOS) and BIOS PC.

VirtualBox needs *Bridged Adapter* to enable access to LAN.


Custom Packages
===============

How `local proxy`_ and `custom packages`_ is used by `rollarch`_:

- The repo for the (meta = dependencies only) `custom packages`_ is named ``custom``.

- An optional ``AIP2=yes`` makes the install a `local proxy`_.
  You can do this after installation with:

  .. code:: sh

    . rollarch
    setup_arch_proxy

- To make/update custom packages in the proxy, do

  .. code:: sh

    #git clone --recurse-submodules https://github.com/rpuntaie/rollarch
    #git submodule foreach git pull origin master
    ## or
    #make update
    cd rollarch
    sudo -E bash ./build
    ## or
    #make
    ##result in pkg/xyz/rollarch.log

  Before doing so,
  you can add some packages from AUR into the ``pkg`` subfolder, e.g.

  .. code:: sh

     git submodule add https://aur.archlinux.org/discord pkg/discord
     #add "ignore = dirty" to .gitmodules
     #when removing, note, that modules are listed also in .git/config
     #see Makefile

  The ``build`` script

  - needs `clean-chroot-manager <https://github.com/graysky2/clean-chroot-manager>`__ installed,
    with pull https://github.com/graysky2/clean-chroot-manager/pull/77::

      yay -S clean-chroot-manager
      ###### add to /etc/fstab
      #tmpfs /scratch tmpfs nodev,size=4G 0 0
      ###### new /etc/tmpfiles.d/ccm_dir.conf
      #d /scratch/.buildroot 0750 root users -

  - builds all packages or THOSE PROVIDED (e.g. ``pkg/yay``)
  - adds the packages to `custom packages`_

  ``build`` may need additional packages in its chroot environment for building certain AUR packages.

- Make a new install with on another machine with

  .. code:: sh

      DSK=/dev/sda USR=u PW=p HST=u106 IP2=1.106 AIP2=1.108 ZONE=Vienna bash installarch <your-packages>

  The optional ``your-packages`` are either provided by the ArchLinux repos or by a `local proxy`_ (AIP2) of yours.
  The optional ``AIP2=x.y``, e.g. ``1.108``, uses ``192.168.1.108`` as `local proxy`_.
  ``mirrorlist`` gets a ``Server = 191.168.1.108`` at the top.
  If the install script finds a repo there named ``custom``, ``pacman.conf`` is changed to use it.

- For packages ending in ``-meta``, at the end of installation,
  the dependencies are made ``--asexplicit`` and the resulting orphaned ``your-meta`` package is removed.
  To make this work, meta packages must not depend on each other.

  ``-meta`` packages are not used any more,
  as `include dotfiles`_ better lists the packages directly.

  To build only the one package do, e.g.::

    sudo -E bash ./build pkg/yay

Include dotfiles
================

The Archlinux `dotfiles`_ wiki shows different methods to install dot files.
A shell script can be wrapped over all of these methods.

This install script can be communicated to rollarch with a ``DOTS`` define.

- ``DOTS`` specifies the URL to your installation script::

    DOTS=https://...
    DOTS=file:///...
    DOTS=SHORT ... meaning https://git.io/SHORT

  For other `shorteners <https://bit.do/list-of-url-shorteners.php>`__ use ``http://...``.

The installation script is forwarded to bash within ``arch-chroot``, after ``cd /home/$USR``.
It

- downloads/clones the dotfiles
- installs them
- does some additional setup

The ``#DFN: ``, ``#PKG:`` and ``#REPO:`` comments are used by `rollarch`_.
The packages provided as arguments to ``rollarch``
are combined with ``#PKG:`` comments in the ``DOTS`` file.

As an example see my
`dotfiles install script <https://github.com/rpuntaie/dotfiles/blob/desktop/install>`__.
It can be reached via the github short https://git.io/fjVcp.
In my example I use only ``rpuntaie-meta`` served from a LAN machine prepared with ``sudo -E ./build``,
which also builds the AUR submodules that are part of `rollarch`_, e.g. ``yay``.

You don't need to clone `rollarch`_ and run ``sudo -E bash ./build`` and use ``AIP2``.
You can just list all the official packages directly in your install script::

        #PKG: bash
        #PKG: bzip2
        #PKG: coreutils
        #...

``#REPO:`` lines work with server addresses that
`don't need a Key-ID <https://wiki.archlinux.org/index.php/Unofficial_user_repositories>`__.
E.g. to also install ``yay`` you could have these two lines::

        #REPO: arcanisrepo
        #PKG: yay

The following installs my system with ``dotfiles`` and packages wanted by it.

.. code:: sh

    curl -OLs https://git.io/installarch
    DSK=/dev/sda USR=u PW=p HST=u106 IP2=1.106 AIP2=1.108 ZONE=Vienna DOTS=fjVcp bash installarch


.. _`local proxy`: https://wiki.archlinux.org/index.php/Pacman/Tips_and_tricks#Network_shared_pacman_cache
.. _`custom packages`: https://wiki.archlinux.org/index.php/Pacman/Tips_and_tricks#Custom_local_repository
.. _`dotfiles`: https://wiki.archlinux.org/index.php/Dotfiles
.. _`rollarch`: https://github.com/rpuntaie/rollarch/blob/master/rollarch




