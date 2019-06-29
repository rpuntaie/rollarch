********
Rollarch
********

Purpose
=======

Automates Arch Linux installation by

- install script and
- custom packages

All parameters are provided at call time,
as an automation should not bombard you with questions.

Look into `rollarch`_ to see what is done during installation.

Usage
=====

After booting the installation medium in the ``archiso`` prompt do

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

:IP2: (192.168.)x.y, [e.g. 1.106], else DHCP is set up
:SWAP: [on|off] (off), set to ``on`` for non-SSD
:IP2:  For 192.168.1.106, else 'dhcp'
:LA_NG: Space separated list of xx_YY used in addition to en_US [e.g. "de_DE ru_RU"]
        Don't include ``en_US``.
:AIP2: [e.g. 1.199 | yes, to create Arch Proxy].
       The x.y of another arch linux machin (the local proxy)
:DOTS: Full URL or ``https://git.io/SHORT`` to a bash installation script for dot files
:KM: (US) one of ``localectl list-keymaps``.
     If in upper case: ESCAPE->CAPS_LOCK and CAPS_LOCK->WIN

Alternatively you can clone to another LAN box (e.g. 1.108) and add the path to NFS

/etc/exports::

   # Use `exportfs -arv` to reload.
   /path/to/rollarch	    192.168.1.0/24(rw,sync,subtree_check)

Then in the ``archiso`` prompt:

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

How `local proxy`_ and `custom packages`_ is used:

- The repo for the (meta = dependencies only) `custom packages`_ is named ``custom``.

- An optional ``AIP2=yes`` makes the install a `local proxy`_.
  You can do this after installation with:

  .. code:: sh

    . rollarchroot
    setup_arch_proxy

- To make/update custom packages in the proxy, do

  .. code:: sh

    cd rollarch
    sudo ./build

  Before doing so, 
  you can clone some packages from AUR into the ``pkg`` subfolder.

  The ``build`` script 

  - fetches the submodules from AUR
  - builds all packages
  - adds to, and merges your ``custom`` repo and `custom packages`_
    with the rest of the packages of the `local proxy`_.

- Make a new install with

  .. code:: sh

      DSK=/dev/sda USR=u PW=p HST=u106 IP2=1.106 AIP2=1.108 ZONE=Vienna bash installarch <your-packages>

  The optional ``your-packages`` are either provided by the ArchLinux repos or by a `local proxy`_ (AIP2) of yours.
  The optional ``AIP2=x.y``, e.g. ``1.199``, uses ``192.168.1.199`` as `local proxy`_.
  ``mirrorlist`` gets a ``Server = 191.168.1.199`` at the top.
  If the install script finds a repo there named ``custom``, ``pacman.conf`` is changed to use it.

- For packages ending in ``-meta``, the dependencies are made ``--asexplicit`` and the resulting orphaned ``your-meta`` package is removed.
  To make this work meta packages must not depend on each other.

  Examples:

  - ``mdaffin-meta``: Transformed from `arch-pkgs`_ to fit to the above guidelines. Also configures, globally.
  - ``rpuntaie-meta``: `dotfiles`_ are installed afterwards. See `include dotfiles`_.

Include dotfiles
================

The Archlinux `dotfiles`_ wiki shows different methods to install dot files.
A shell script can be wrapped over all of these methods.

For this add a ``DOTS`` define.

- ``DOTS`` specifies your 
  `possibly shortened <https://bit.do/list-of-url-shorteners.php>`__
  URL (default: ``https://git.io/SHORT``) to a script that is directly forwarded to bash and does all the installation
  including downloading/cloning.
  The script is executed from within ``arch-chroot``, after ``cd /home/$USR``.


The ``#PKG:`` and ``#REPO:`` lines in my 
`dotfiles install script <https://github.com/rpuntaie/dotfiles/blob/desktop/install>`__
are used by `rollarch`_.
``#REPO:`` lines work with server addresses that 
`don't need a Key-ID <https://wiki.archlinux.org/index.php/Unofficial_user_repositories>`__.
They are copied to the `rollarch`_ file and used from there.

With a github short like https://git.io/fjVcp, the following installs with ``dotfiles`` and packages wanted by it

.. code:: sh

    curl -OLs https://git.io/installarch #inspect, modify
    DSK=/dev/sda USR=u PW=p HST=u106 IP2=1.106 AIP2=1.108 ZONE=Vienna DOTS=fjVcp bash installarch

Thanks
======

Inspired by `mdaffin`_ and
`how to create archlinux repository <https://fusion809.github.io/how-to-create-archlinux-repository/>`__.


.. _`mdaffin`: https://github.com/mdaffin/arch-pkgs
.. _`local proxy`: https://wiki.archlinux.org/index.php/Pacman/Tips_and_tricks#Network_shared_pacman_cache
.. _`custom packages`: https://wiki.archlinux.org/index.php/Pacman/Tips_and_tricks#Custom_local_repository
.. _`dotfiles`: https://wiki.archlinux.org/index.php/Dotfiles
.. _`rollarch`: https://github.com/rpuntaie/rollarch/blob/master/rollarch




