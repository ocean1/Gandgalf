rm *.com
nasm embeddedcom.s -o main.com
lz4c -y -l main.com main.lz4 2> /dev/null
nasm unpack.s -o unpack.com
cat unpack.com main.lz4 > embed.com
