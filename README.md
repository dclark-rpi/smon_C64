# SMON

Modified to run on the Commodore 64 again with a few adjustments made.

The rest is pretty much the same....


SMON is a machine language monitor and direct assembler for the Commodore 64,
published in 1984 in "64'er" magazine (for more info see the [credit section](https://github.com/dclark-rpi/smon6502#credits) below).

In a nutshell, SMON provides the following functionality:
  - View and edit data in memory
  - Disassemble machine code
  - Write assembly code directly into memory (direkt assembler with support for labels)
  - Powerful search features
  - Moving memory, optionally with translation of absolute addresses
  - Trace (single-step) through code
  - Set breakpoint or run to a specific address and continue in single-step mode

The best description of SMON's commands and capabilities is the article in the
64'er magazine (in German) [available here](https://archive.org/details/64er_sonderheft_1985_08/page/n121/mode/2up).
For English speakers, C64Wiki has a brief [overview of SMON commands](https://www.c64-wiki.com/wiki/SMON).

I've included both an English and German transcript in plain text of the original 4 part article in the Docs folder.

## SMON for 6502

The version published here is an adaptation of SMON for a simple MOS6502-based 
computer, such as the one built by [Ben Eater](https://eater.net/6502) in his 
[YouTube video series](https://www.youtube.com/watch?v=LnzuMJLZRdU&list=PLowKtXNTBypFbtuVMUVXNR0z1mu7dp7eH).
The following original or rp6502 SMON functions are **not** available in this version:
  - load files in Intel HEX format into the 6502 by pasting them into the terminal (L command)
  - Sending output to a printer (P command)
  - Disk monitor mode and other extensions
  
The following new commands have been added in this version
  - B - Producing BASIC DATA statements for memory content
  - H - show a help screen with a brief overview of available commands
  - L/S/I  - Loading and saving programs/data to disk or tape
  - MS - check and print size of installed memory
  - MT - test memory
  - If you press the left arrow key (Top left key on commodore keyboard) and press return,
    it will perform a hard reset of the computer, but won't delete anything located in program memory.

## Installing and running SMON 6502

If you are using Ben Eater's standard setup (16k RAM at $0-$3FFF, ACIA at $5000, VIA at $6000, ROM at $8000-$FFFF, 1MHz clock)
you can just download the [smon.bin](https://github.com/dhansel/smon6502/raw/main/smon.bin) file from
this repository and burn it to the EEROM.

Connect your terminal or USB-to-serial converter to the 65C51N ACIA as described by Ben in his videos.

Configure your terminal (program) for 9600 baud, 8 data bits, 1 stop bit and no parity. After turning
on the 6502 you should see SMON showing the 6502 register contents and command prompt.

If you are using a non-standard setup, SMON can easily be adapted by changing the settings
in the `config.asm` file (see below).

## Basic usage

At startup, SMON shows the current 6502 processor status, followed by a "." command prompt
```
  PC  SR AC XR YR SP  NV-BDIZC
;800B B0 89 00 00 F6  10110000
.                             
```
Where "PC" is the program counter, "SR" is the status register, "AC" is the accumulator, "XR" and "YR" are
the X and Y registers and "SP" is the stack pointer. the "NV-BDIZC" column shows the individual bits
in the status register.

At the command prompt you can enter commands. For example, entering "M 1000 1030" will show the memory
content from $1000-$1030:
```
.M 1000 1030                                                                    
:1000 00 00 FF FF FF FF 00 00   ........
:1008 00 00 FF FF FF FF 00 00   ........
:1010 00 00 FF FF FF FF 00 00   ........
:1018 00 00 FF FF FF FF 00 00   ........
:1020 00 00 FF FF FF FF 00 00   ........
:1028 00 00 FF FF FF FF 00 00   ........
```
The column on the right shows the (printable) ASCII characters corresponding to the data bytes.

If your terminal supports the VT100 cursor movement sequences, you can **modify** the memory
content by just moving the cursor into the displayed lines, editing data and pressing ENTER
on each line where data was modified. 

If your terminal does not support cursor keys you can
modify memory by typing (for example) 

```
:1015 AA BB
```
and pressing ENTER. The example here will set $1015 to AA and $1016 to BB.

If you supply only one argument to the "M" command, SMON will show the memory content line-by-line,
stopping after each line. Press SPACE to advance to the next line, ESC to go back to the command prompt
or any other key to keep displaying memory without pausing (press SPACE to pause the scrolling display).

The "D" (disassemble) command will disassemble code in memory, for example:
```
.D F000
  PC   MACHINE   OPC  ADR
,F000  DD 09 02  CMP  0209,X
,F003  8D 01 DD  STA  DD01
,F006  2C 01 DD  BIT  DD01
,F009  70 07     BVS  F012
,F00B  30 F9     BMI  F006
,F00D  A9 40     LDA  #40
,F00F  8D 97 02  STA  0297
,F012  18        CLC
,F013  60        RTS
--------------------------------
```
The instruction at F000 displayed is wrong as the real instruction starts at EFFE, starting at this
address reveals the correct code. Be careful and check where the code really starts in memory.
The code example actually starts at address EFDB.

You can use the cursor keys to move over the displayed assembly statements and their arguments and modify 
them (assuming the code is in RAM).

You can use the "A" (assemble) command to assemble code directly into memory. SMON will show the current
address as a prompt and you can enter an assembly statement (e.g. `LDX #12`). Press ENTER and SMON will
assemble it, place it directly in memory, and advance the address to the next location according to the
previous opcode's size. To exit assembly mode, type "F" as the opcode. SMON will then show you the full
disassembly of the code you entered, in which you can edit again. For example:
```
.A 2000                  
 2000 LDX #00 
 2002 INX     
 2003 BNE 2002
 2005 BRK     
 2006 F                  
,2000  A2 00     LDX #00 
,2002  E8        INX     
,2003  D0 FD     BNE 2002
,2005  00        BRK     
```

To run your code just enter `G 2000`. Note that to jump back into SMON after your code
finishes, it should end with a `BRK` instruction.

SMON also allows you to single-step through code using the `TW` (trace walk) command. For example:

```
.R

  PC  SR AC XR YR SP  NV-BDIZC
;800B B0 89 00 00 F6  10110000
.TW 2000
                      
 2002 23 E9 00 FF FF  00100011   INX     
 2003 21 E9 01 FF FF  00100001   BNE 2002
 2002 21 E9 01 FF FF  00100001   INX     
 2003 21 E9 02 FF FF  00100001   BNE 2002
 2002 21 E9 02 FF FF  00100001   INX     
 2003 21 E9 03 FF FF  00100001   BNE 2002

  PC  SR AC XR YR SP  NV-BDIZC
;2003 21 E9 03 FF FF  00100001
```

After entering the `TW` command, SMON executes the first opcode and stops after
finishing it and displays the next opcode (the first opcode is not shown).
It also shows you the processor registers in the same order as they appear in the
register display line. Press any key to advance one step or ESC to stop.
If the next command is a `JSR`, press 'J' to "jump" over the subroutine and
continue after it finishes (this only works if the `JSR` command is located in RAM).

SMON has a number of other "trace" related commands, a range of "find"
commands to examine memory and several other commands. To get a quick overview
of commands type "H" at the command line. For a bit more information on each command,
refer to the [C64Wiki](https://www.c64-wiki.com/wiki/SMON) page or for the full description 
read the [64er article](https://archive.org/details/64er_sonderheft_1985_08/page/n121/mode/2up) 
(in German).

### Load / Save your program

To save a file the command is,
.S"Filename" xxxx yyyy
for example
.S"TEST" 4000 400A 
the filename is TEST and the program is stored in address 4000 to 4009, to correctly store the whole program you need to add one to the last address to be saved to disk. If you don't do this you will find the last line of your program missing.

To load a file the command is,
.L"Filename" 
for example
.L"TEST" 
this will load the program at the original address that was saved, if you would like to store it at a new address you would enter the following to load at address 5000 instead.
.L"TEST" 5000 

### Memory size and test

The new "MS" (memory size) command checks memory starting at address $0100 and upwards until it finds
and address where a read after write does not result in the same data. It then shows that address as
the memory size.

The "MT xxxx yyyy [nn]" command tests memory between $xxxx and $yyyy by writing different patterns
of data to it and checking whether the data reads back the same. Each time a difference is found
the corresponding address is printed. The optional "nn" parameter specifies a repetition count
(defaults to 1). At the end of each test, a "+" is printed.

## Configuring SMON 6502

There are three basic settings that can be changed by modifying the `config.asm` file:
  - RAM size (default: 16k). RAM is assumed to occupy the address space from $0 to the RAMTOP setting.
    For example, if you have 32K of RAM then set RAMTOP to $7FFF
  - VIA location (default: $6000). Change this if the location of the VIA differs from the default setting.
  - Clock speed (default: 1000000). Change this if your system's clock is running at a different rate
    than the standart 1MHz. This setting is used for UART timing.
  - UART driver. Communication with SMON works via RS232 protocol. The following UARTs are supported at this point:
    - *WCS 65C51N ACIA (default)*. This is the UART Ben Eater is using in his project. The serial parameters are
      set to 9600 baud, 8 data bits, 1 stop bit and no parity. You can change the serial parameters and base
      address for the ACIA at the top of the `uart_6551.asm` file.
    - *Pseudo-UART using 6522 VIA*.  This emulates a UART using the 6522 VIA present in Ben Eater's design. 
      The serial parameters can be modified at the top of `uart_6522.asm` and default to 1200 baud 8N1.
      Note that on a 1MHz system baud rates above 1200 may lead to corruption of received data.
      Connect your terminal (or serial-to-usb adapter) to the VIA as follows: 
        - Receive (RX) pin of the terminal goes to pin 39 (CA2) of the VIA.
        - Transmit (TX) pin of the terminal goes to pin 40 (CA1) **and** pin 2 (PA0) of the VIA.
        - Make sure the VIA's pin 21 (IRQ) is connected to the 6502 CPU's pin 4 (IRQ)
      The RX and TX pins can also be configured at the top of `uart_6522.asm`.
    - *Motorola MC6850*. If you choose this UART in the config.asm file you can configure it in the `uart_6850.asm` file,
      most importantly the base address (default is $8100) and the serial parameters

## Compiling SMON 6502

To produce a binary file that can be used with the commodore 64 computer,
do the following:
 
  1. Download the `*.asm` files from this repository and place into a directory named "src"
  2. Download the VASM compiler ([vasm6502_oldstyle_Win64.zip](http://sun.hasenbraten.de/vasm/bin/rel/vasm6502_oldstyle_Win64.zip)).
  3. Extract `vasm6502_oldstyle.exe` from the archive and put it into the root directory that contains the src directory
  4. Issue the following command: `python3 build.py`

Then just import the generated smon.prg file to a .D64 floppy image using whichever program that supports your operating system that
you have been using.
I have been using ([DirMaster 3.1.5](https://style64.org/dirmaster)) for windows

I can confirm that the above instructions worked on Windows 10 to compile the code and to transfer to a floppy image that runs on VICE,
and C64 computers that accept floppy images by USB Flash Drive. It should work on any C64 if you can transfer the smon.prg to your computer.

## Running Commodore 64 SMON

Load the prg or d64 floppy image on either a real commodore 64 or vice.
use the following command to load the floppy image,

``` LOAD"*",8,1  ```

it will display the following,

```
     SEARCHING FOR *
     LOADING
     READY
```
then type,

```  RUN  ```

after it displays READY again type the following to launch the program,

```  SYS 32768  ```

## Running Commodore BASIC

After implementing the C64 kernal functions necessary to get SMON to work I realized that
the same functions are enough to run Commodore BASIC. Installing and/or compiling BASIC
follows the same rules as SMON (just use `basic.bin` or `basic.asm`).

Note that this is more of a toy example since only very simple BASIC programs will work
(nothing with graphics or sound). Also saving or loading programs is obviously not supported.

## Credits

The SMON machine language monitor was originally published in a four part article in the following issues, 
[November 1984](https://archive.org/details/64er_1984_11/page/n59/mode/2up)
/ [December 1984](https://archive.org/details/64er_1984_12/page/n59/mode/2up)
/ [January 1985](https://archive.org/details/64er_1985_01/page/n68/mode/2up) 
/[February 1985](https://archive.org/details/64er_1985_02/page/72/mode/2up).

The 64'er Magazine published "Machine Language Assembly for Beginners and Advanced Users" containing a full manual and assembler source for SMON Complete in [August 1985](https://archive.org/details/64er_sonderheft_1985_08/page/n121/mode/2up)

Bug fixes for the original SMON was published in [December 1985](https://archive.org/details/64er_1985_12/page/100/mode/2up) Tricks and Tips for SMON article, which included some new additions.

1984/85 issues of German magazine "[64er](https://www.c64-wiki.com/wiki/64%27er)".

SMON was written for the Commodore 64 by Norfried Mann and Dietrich Weineck.

The [code](https://github.com/dhansel/smon6502/blob/main/smon.asm) here is based 
on a (partially) commented [disassembly of SMON](https://github.com/cbmuser/smon-reassembly/blob/master/smon_acme.asm)
by GitHub user Michael ([cbmuser](https://github.com/cbmuser)).

The [code](https://github.com/dhansel/smon6502/blob/main/uart_6522.asm) for handling RS232 communication via the 6522 VIA chip was taken
and (heavily) adapted from the VIC-20 kernal, using Lee Davidson's 
[commented disassembly](https://www.mdawson.net/vic20chrome/vic20/docs/kernel_disassembly.txt).

The [code](https://github.com/dhansel/smon6502/blob/main/uart_6551.asm) for handling RS232 communication via the 
65C51N ACIA chip was put together and tested by Chris McBrien, based on the ACIA code from 
[Adrien Kohlbecker](https://github.com/adrienkohlbecker/65C816/blob/ep.30/software/lib/acia.a).

The code for the RP6502 Picocomputer port was provided by [Jim Morris](https://github.com/wolfmanjm/smon6502).

The bug in the Occupy command stopping the full memory range from being changed is fixed, also the missing call to the reset kernel function was added back into the code to allow it to properly initialise the processor and clear the line buffer. All changes to Jim Morris's port to the RP6502  was provided by [David Clark](https://github.com/dclark-rpi/)
