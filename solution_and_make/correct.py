url = ("kwws", 199, 23, 253, 140, "nbd`o0", "_Q\xc8gN\x07\x87\xd6\xc0U")

out = ""
for i in url[0]:
    out += chr(ord(i) ^ 3)

out += "://"

out += "%d" % (url[1] ^ 7)
out += '.'
out += "%d" % (url[2] ^ 9)
out += '.'
out += "%d" % (url[3] ^ 1)
out += '.'
out += "%d" % (url[4] ^ 1)

out += "/"

for i in url[5]:
    out += chr(ord(i) ^ 1)

out += "/"

for i in url[6]:
    out += "%02x" % (ord(i) ^ 1)

print out
