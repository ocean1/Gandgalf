from sys import argv;from Crypto.Cipher import AES;
keyfile=argv[1];flag=';\xf4k\xcb\xcb\xd0\x86~\x0c\td\xf9\xe9BA\xaa8\xb3\xfcW/\xfe\xd6\x16\xae%\x9b\xa7\r\x08\x1d\x1a'
with open(keyfile,"r") as kf:
 i=int(argv[2]);l=int(argv[3])
 aes=AES.new(kf.read()[i:i+l],AES.MODE_CBC,'dng3rousb1zFr0do')
 flag=aes.decrypt(flag)
 print flag[0:len(flag)-ord(flag[-1])]
