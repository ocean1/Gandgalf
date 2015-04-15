from sys import argv;from Crypto.Cipher import AES;
keyfile=argv[1];flag='\r$\xa5/W\xfa\xcc\xec\xf0Cy\xf6\x1dlq\xa6\n\xd6\xdd\xf3\xe4c\x17Z\xaf\xef\xd4Yw\xe7\xcc\xed';
with open(keyfile,"r") as kf:
 i=int(argv[2]);l=int(argv[3])
 aes=AES.new(kf.read()[i:i+l],AES.MODE_CBC,'dng3rousb1zFr0do')
 flag=aes.decrypt(flag)
 print flag[0:len(flag)-ord(flag[-1])]