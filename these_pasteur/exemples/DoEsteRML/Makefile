RPMLBUILD=/Users/ccpasteur/Documents/work/git/rml/tools/rpmlbuild/rpmlbuild/_build/ocamlbuild.byte

.PHONY: clean FORCE

all: doesterml.rml.d.byte

%.rml.d.byte: FORCE
	rm -f $@
	$(RPMLBUILD) -no-links $@
	cp _build/$@ .

%.rml.native: FORCE
	rm -f $@
	$(RPMLBUILD) -no-links $@
	cp _build/$@ .

clean:
	rm -rf _build
	rm -f *.byte *.native

test: FORCE
	cd test && ./gen_tests > CTestTestfile.cmake
	cd test/ && ctest

FORCE:
