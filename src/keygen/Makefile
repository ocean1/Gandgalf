all: build

clean:
	-$(RM) keygen.xored.gz

build:
	cat keygen.py | gzip -n > /tmp/keygen.py.gz
	python create_xored_gz.py /tmp/keygen.py.gz

