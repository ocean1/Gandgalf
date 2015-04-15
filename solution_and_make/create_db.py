with open("keygen.py.gz", 'r') as kg:

    out = ""
    key = 0xeb
    keyfile = kg.read()
    #for i in keyfile:
    #    out += chr(ord(i) ^ key
    print "\\x".join("{:02x}".format(ord(c) ^ key) for c in keyfile)
    #print out.__repr__()
