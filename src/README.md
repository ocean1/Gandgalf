# this is a multi-step challenge.

## STEP 1

the first step is to correct the url, you just need to ignore the flag parameter

hints given during CTF:
  + do NOT expect the correct URL to be in the amazon ip range
  + ping polictf.it
      
doing ping polictf.it it's easy to see an ip which is from github:
PING polictf.it (192.30.252.154) 56(84) bytes of data.

if you search for differences with the ip given you will see that it is just a XOR operations with the numbers present in the rhyme of lore of the LOTR.

you just need to correct it (see src/solution/correct.py)
you will obtain:
http://192.30.252.141/ocean1/5e50c9664f0686d7c154
which won't work like that, but if you "host" the ip you'll see it is just a gist :)

the gist contains a keyfile which you'll need to use later to decrypt the flag using keygen.py

## STEP 2
inside the png there is a DOS executable embedded in the blue channel
(the pixels are embedded in columns -not in rows!- as you can just looking closely at the picture and seeing "strange yellow pixels" in the first 2/3 columns)

hints given:
   - john loves that song: https://www.youtube.com/watch?v=OwDdbZSo4AY (taking back sunday : the blue channel)
   - 90 90 90 90 EB 02 CD 21 -> DOS 16 bit COM

## STEP 3
you got to reverse engineer the embedded COM file and extract the keygen.py correctly
(you'll need to mount a floppy image in dosbox and patch the int3 since there is a debugger by default in DOSBOX,
and we check for the debugger presence, expecting an IRET opcode in the int vector for int3, see the README inside src/embeddedcom for more info!)

no hints


## STEP 4
you just need to substitute the flag string that was the parameter of the url you didn't change before, and bruteforce the parameters of the keygen
(start address in the keyfile, and AES key size).

if you don't substitute the flag you'll find a fake flag which is not working.


