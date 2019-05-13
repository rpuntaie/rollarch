Automates Arch Linux installation to

- not repeat the steps manually to often xor
- remember the steps

All parameters are provided at call time,
as an automation should not bombard you with questions.

Look into ``rollarch`` to see what is done during installation.

Usage:

.. code:: sh

    curl -OLs https://git.io/installarch
    DISK=/dev/sda USR=A PW=B PC=C IP2=1.106 ZONE=Berlin bash installarch
    

The url is short for ``https://raw.githubusercontent.com/rpuntaie/rollarch/master/rollarch``.

Based on
`archibold <https://github.com/WebReflection/archibold.io/tree/gh-pages>`__.

Status: 

- Tested and works for 
  - Virtualbox (EFI and BIOS) and 
  - BIOS PC
- I have no EFI PC: 
  If you are about to install Arch on an EFI PC, try it and report in Issues.


