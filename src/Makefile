OUTS = keygen.py.gz keygen.xored.gz Ub7XL8T.png

DIRS = keygen embeddedcom

all: build

clean:
	-$(RM) $(OUTS)
	-for d in $(DIRS); do (cd $$d; $(MAKE) clean ); done

build:

	cd keygen; $(MAKE)
	cd embeddedcom; $(MAKE)
	
	- python gen_image.py embeddedcom/embed.com
	cp Ub7XL8T.png ../
	@echo "\nDONE!\n"

