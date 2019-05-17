Automates Arch Linux installation by

- install script and
- custom packages

All parameters are provided at call time,
as an automation should not bombard you with questions.

Look into `rollarch`__ to see what is done during installation.

__ https://github.com/rpuntaie/rollarch/blob/master/rollarch

Usage:

.. code:: sh

    curl -OLs https://git.io/installarch #inspect, modify
    DSK=/dev/sda USR=A PW=B HST=C IP2=1.106 ZONE=Berlin bash installarch
    

The URL is short for ``https://raw.githubusercontent.com/rpuntaie/rollarch/master/rollarch``.

Inspired by:

- `archibold <https://github.com/WebReflection/archibold.io/tree/gh-pages>`__.
- `arch-pkgs <https://github.com/mdaffin/arch-pkgs>`__
- `how to create archlinux repository <https://fusion809.github.io/how-to-create-archlinux-repository/>`__

Status: 
Tested for VirtualBox (EFI and BIOS) and BIOS PC.

VirtualBox needs *Bridged Adapter* to enable access to LAN.


----


An optional ``AIP2=x.y``, e.g. ``1.199``, uses ``192.168.1.199`` as `local proxy`_.
``AIP2=yes`` makes this install a `local proxy`_ by including:

.. code:: sh

   ln -s /var/lib/pacman/sync/*.db /var/cache/pacman/pkg
   cd /usr/lib/systemd/system/
   cat darkhttpd.service | sed -e "s/Webserver/ArchProxy/g" -e "s,/srv/http.*$,/var/cache/pacman/pkg --no-server-id --port 8080,g" > ArchProxy.service
   systemctl --now enable ArchProxy

You can then *manually* merge in your folder with ``custom.db.tar.gz`` via

.. code:: sh

   find /abs/path/to/folder -maxdepth 1 -and -not -type d -exec ln -sf {} /var/cache/pacman/pkg \;


----


About (meta = dependencies only) `custom packages`_: 

- Name the custom repo ``custom``.

- You can serve them from a local folder (e.g. CIFS or NFS mount), which contains

  - ``custom.db.tar.gz``
  - created via ``repo-add custom.db.tar.gz your-*.pkg.tar.xz``.

    - To create a ``*.pkg.tar.xz``, have a folder with a ``PKGBUILD`` and 
    - do ``makepkg`` there, then 
    - move the ``*.pkg.tar.xz`` to the ``custom`` package folder

- uncomment and edit the ``custom`` entry at the end of ``/etc/pacman.conf``
- ``pacman -Sy your``

.. _`local proxy`: https://wiki.archlinux.org/index.php/Pacman/Tips_and_tricks#Network_shared_pacman_cache
.. _`custom packages`: https://wiki.archlinux.org/index.php/Pacman/Tips_and_tricks#Custom_local_repository

