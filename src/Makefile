OUTS = keygen.py.gz keygen.xored.gz Ub7XL8T.png

DIRS = keygen embeddedcom

all: build

clean:
	-$(RM) $(OUTS)

build:
	cat keygen.py | gzip -n > keygen.py.gz
	python create_xored_gz.py
	cd embeddedcom
	$(MAKE)
	cd ../
	
	- python gen_image.py embeddedcom/main.com
	cp Ub7XL8T.png ../
	echo "\nDONE!\n"

