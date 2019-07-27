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

After booting the installation medium in the ``archiso`` prompt, do

.. code:: sh

    curl -OLs https://git.io/installarch #inspect, modify
    DSK=/dev/sda USR=u PW=p HST=u106 IP2=1.106 ZONE=Berlin bash installarch

``https://git.io/installarch`` is short for
``https://raw.githubusercontent.com/rpuntaie/rollarch/master/rollarch``.

:DSK: disk on which to install (not partition)
:USR: main user of the system
:PW: password of main user
:HST: host name of the system
:ZONE: a city name ending that can be found in ``/usr/shar/zoneinfo``

Optional:

:IP2: (192.168.)x.y, [e.g. 1.106], else dhcp; for en+wl, wl gets ip2+1
:SWAP: [on|off] (off), set to ``on`` for non-SSD
:IP2:  For 192.168.1.106, else 'dhcp'
:LA_NG: Space separated list of xx_YY used in addition to en_US [e.g. "de_DE ru_RU"]
        Don't include ``en_US``.
:KM: (us) one of ``localectl list-keymaps``.
:CL: If given, Escape is mapped to Caps_Lock and Caps_Lock to this key for VConsole.
     For X instead use dotfiles, e.g.: xmodmap -e "keysym Print = Caps_Lock
     99 is [Print], 125 is [Win] aka Super_L.
:AIP2: [e.g. 1.199 | yes, to create Arch Proxy].
       The x.y of another arch linux machin (the local proxy)
:DOTS: Full URL or ``https://git.io/SHORT`` to a bash installation script for dot files
:ESSID: name of WLAN access point, if any
:PSK: passphrase of WLAN access point, if any

The ``AIP2`` and ``DOTS`` defines are very useful and will be addressed below.

Alternatively you can clone `rollarch`_ to another LAN box (e.g. 1.108) and add the path to NFS

/etc/exports::

   # Use `exportfs -arv` to reload.
   /path/to/rollarch	    192.168.1.0/24(rw,sync,subtree_check)

Then at the ``archiso`` prompt:

.. code:: sh

    mkdir rollarch
    mount -t nfs 192.168.1.108:</path/to/rollarch> rollarch
    cd rollarch
    DSK=/dev/sda USR=u PW=p HST=u106 IP2=1.106 ZONE=Berlin bash rollarch


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

    . rollarchroot
    setup_arch_proxy

- To make/update custom packages in the proxy, do

  .. code:: sh

    #git clone --recurse-submodules https://github.com/rpuntaie/rollarch
    #git submodule foreach git pull origin master
    cd rollarch
    sudo bash ./build

  Before doing so,
  you can add some packages from AUR into the ``pkg`` subfolder, e.g.

  .. code:: sh

     git submodule add https://aur.archlinux.org/discord pkg/discord

  The ``build`` script

  - updates the submodules from AUR
  - builds all packages or the THOSE PROVIDED (``pkg/rpuntaie``)
  - adds to, and merges your ``custom`` repo and `custom packages`_
    with the rest of the packages of the `local proxy`_.

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

  Examples:

  - ``mdaffin-meta``: Transformed from `arch-pkgs`_, to fit to the above guidelines. Also configures, globally.
  - ``rpuntaie-meta``: `dotfiles`_ are installed afterwards. See `include dotfiles`_.

Include dotfiles
================

The Archlinux `dotfiles`_ wiki shows different methods to install dot files.
A shell script can be wrapped over all of these methods.

This install script can be communicated to rollarch with a ``DOTS`` define.

- ``DOTS`` specifies the URL to your installation script.
  - ``DOTS=https://...``
  - ``DOTS=file:///...``
  - ``DOTS=SHORT``, meaning ``https://git.io/SHORT``
    For other `shorteners <https://bit.do/list-of-url-shorteners.php>`__ use ``http://...``.

The installation script is forwarded to bash within ``arch-chroot``, after ``cd /home/$USR``.
It

- downloads/clones the dotfiles
- installs them
- does some additional setup

The ``#PKG:`` and ``#REPO:`` comments are used by `rollarch`_.
The packages provided as arguments to ``rollarch``
are combined with ``#PKG:`` comments in the ``DOTS`` file.

As an example see my
`dotfiles install script <https://github.com/rpuntaie/dotfiles/blob/desktop/install>`__.
In my example I use only ``rpuntaie-meta`` served from a LAN machine prepared with ``sudo ./build``,
which also builds the AUR submodules that are part of `rollarch`_, e.g. ``yay``.

You don't need to clone `rollarch`_ and run ``sudo bash ./build`` and use ``AIP2``.
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

My dotfiles can be reached via the github short https://git.io/fjVcp.
The following installs my system with ``dotfiles`` and packages wanted by it.

.. code:: sh

    curl -OLs https://git.io/installarch
    DSK=/dev/sda USR=u PW=p HST=u106 IP2=1.106 AIP2=1.108 ZONE=Vienna DOTS=fjVcp bash installarch

When booting into the new system, I currently still need to run ``~/dotfiles/install`` again.
The run in ``arch-chroot`` seems unable to accomplish its full task. I don't know why, yet.

Thanks
======

Inspired by `mdaffin`_ and
`how to create archlinux repository <https://fusion809.github.io/how-to-create-archlinux-repository/>`__.


.. _`mdaffin`: https://github.com/mdaffin/arch-pkgs
.. _`local proxy`: https://wiki.archlinux.org/index.php/Pacman/Tips_and_tricks#Network_shared_pacman_cache
.. _`custom packages`: https://wiki.archlinux.org/index.php/Pacman/Tips_and_tricks#Custom_local_repository
.. _`dotfiles`: https://wiki.archlinux.org/index.php/Dotfiles
.. _`rollarch`: https://github.com/rpuntaie/rollarch/blob/master/rollarch




