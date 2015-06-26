import sys

out = ""
with open(sys.argv[1], 'r') as kg:

    key = 0xEB
    keyfile = kg.read()
    #addition = 0xFE
    addition = 0xCF
    for i in keyfile:
        out += chr((
                (ord(i) ^ key) +
                addition )&0xFF
            )
        addition ^= ord(out[-1:])
    # print "\\x".join("{:02x}".format(ord(c) ^ key) for c in keyfile)
    # print out.__repr__()

with open('keygen.xored.gz', 'w') as kx:
    kx.write(out)
