from sys import argv
from Crypto.Cipher import AES
keyfile = argv[1]

flag = 'close_but_not_your_flag'

print "usage: python keygen.py keyfile"

length = 16 - (len(flag) % 16)
flag += chr(length) * length
with open(keyfile, "r") as kf:
    aes = AES.new(
        kf.read()[15:15+16], AES.MODE_CBC,
        'dng3rousb1zFr0do')
    # print aes.encrypt(flag).__repr__()

    flag = aes.encrypt(flag)
    print flag.__repr__()
