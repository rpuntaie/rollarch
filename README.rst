Automates Arch Linux installation to

- not repeat the steps manually to often xor
- remember the steps

All parameters are provided at call time,
as an automation should not bombard you with questions.


Required::

  DISK [e.g. dev/sdX]
  USR [not "root"]
  PW [e.g. 's$92 37d sdxG?']
  PC network name
  ZONE [e.g. Vienna]

Optional::

  IP2 [e.g. 1.106] for 192.168.1.106, else "dhcp"
  LA_NG in addition to en_US [e.g. de_DE] (none)
  SWAP [on|off] (off) set to on for non-SSD

Example:

.. code:: sh

    curl -OLs https://git.io/installarch
    DISK=/dev/sda USR=A PW=B PC=C IP2=1.106 ZONE=Berlin bash installarch
    

The url is short for ``https://raw.githubusercontent.com/rpuntaie/rollarch/master/rollarch``.

Based on
`archibold <https://github.com/WebReflection/archibold.io/tree/gh-pages>`__.

Status: Tested and works for Virtualbox (EFI and BIOS) and BIOS PC.

