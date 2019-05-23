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

---- 

Status: 
Tested for VirtualBox (EFI and BIOS) and BIOS PC.
Work in progress.

VirtualBox needs *Bridged Adapter* to enable access to LAN.


----


Usage of `local proxy`_ and `custom packages`_:

- The repo for the (meta = dependencies only) `custom packages`_ is named ``custom``.

- An optional ``AIP2=yes`` makes this install a `local proxy`_.

- If you want, the `build` script builds, adds to,
  and merges your ``custom`` repo and `custom packages`_
  with the rest of the packages of the `local proxy`_.

- In a new install, an optional ``AIP2=x.y``, e.g. ``1.199``, uses ``192.168.1.199`` as `local proxy`_.
  ``mirrorlist`` gets a ``Server = 191.168.1.199`` at the top.
  If the install script finds a ``custom`` repo there, ``pacman.conf`` is changed to use it.


.. code:: sh

    DSK=/dev/sda USR=A PW=B HST=C IP2=1.106 ZONE=Berlin bash installarch <your-pacstrap-meta>
    
If the optional ``your-pacstrap-meta`` is provided, it can do setup beyond what ``rollarchroot`` does,
as that is still called afterwards.
If the name ends in ``-meta`` the dependencies are made ``--asexplicit`` and the orphaned package is removed.
To make this work meta packages should not depend on each other.

``mdaffin-meta``, transformed from `arch-pkgs`_, and ``rpuntaie-meta`` are two meta packages.
For the latter: As ``pacman`` does not touch ``$HOME``, `dotfiles`_ should be done after installation,
e.g. via `stow <https://www.gnu.org/software/stow/>`_.


----


Inspired by:

- `archibold <https://github.com/WebReflection/archibold.io/tree/gh-pages>`__.
- `arch-pkgs`_
- `how to create archlinux repository <https://fusion809.github.io/how-to-create-archlinux-repository/>`__



.. _`arch-pkgs`: https://github.com/mdaffin/arch-pkgs
.. _`local proxy`: https://wiki.archlinux.org/index.php/Pacman/Tips_and_tricks#Network_shared_pacman_cache
.. _`custom packages`: https://wiki.archlinux.org/index.php/Pacman/Tips_and_tricks#Custom_local_repository
.. _`dotfiles`: https://wiki.archlinux.org/index.php/Dotfiles
