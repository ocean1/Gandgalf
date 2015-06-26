rm *.com
nasm embeddedcom.s -o main.com
lz4c -y -l main.com main.lz4 2> /dev/null
nasm unpack.s -o embed.com
tail -c +3 main.lz4 >> embed.com
