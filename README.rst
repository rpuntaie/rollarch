Installing Arch Linux is not hard,
but if you want the same packages over and over again,
it is a candidate for automation.

The Arch installation can easily be automated,
because it uses the command line and not a GUI.

All parameters are provided at call time,
as an automation should not bombard you with questions.

Required::

  DISK [e.g. dev/sdX]
  USER [not "root"]
  PASSWORD [e.g. 's$92 37d sdxG?']
  PCNAME network name of PC
  ZONE [e.g. Vienna]
  IP2 [e.g. 1.106] for 192.168.1.106

Optional::

  VERBOSE [on|off] (off)
  LA_NG in addition to en_US [e.g. de_DE] (none)
  SWAP [on|off] (off) set to *on* for non-SSD

Example:

.. code:: sh

    DISK=/dev/sda USR=A PW=B PC=C IP2="1.106" ZONE=Berlin\
    bash <(curl -Ls https://git.io/installarch)
    

The url is short for ``https://raw.githubusercontent.com/rpuntaie/rollarch/master/rollarch``.

Based on
`archibold <https://github.com/WebReflection/archibold.io/tree/gh-pages>`__.

Status: Testing. Not working yet. 

