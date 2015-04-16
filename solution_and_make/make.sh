#!/bin/sh
# cleanup
rm keygen.py.gz
rm Ub7XL8T.png
rm keygen.xored.gz
rm embed.com

# build
cat keygen.py | gzip -n > keygen.py.gz
python create_xored_gz.py
nasm embeddedcom.s -o embed.com
python gen_image.py
cp Ub7XL8T.png ../

echo "\nDONE!\n"