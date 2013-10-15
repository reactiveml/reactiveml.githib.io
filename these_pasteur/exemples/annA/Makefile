include ../../config

.PHONY: clean FORCE

all: memory_last.rml.native domain_example.rml_gen.native

%.rml_gen.native: FORCE
	rm -f $@
	$(RPMLC) -s main -runtime Rpml2rml $*.rml
	echo "sim: main" >> $*_gen.rmlsim
	rmlbuild -no-links $*_gen.rml.native
	cp _build/$*_gen.rml.native $@
	rm $*_gen.rmlsim

%.rml.byte: FORCE
	rm -f $@
	$(RPMLBUILD) -no-links $@
	cp _build/$@ .

%.rml.d.byte: FORCE
	rm -f $@
	$(RPMLBUILD) -no-links $@
	cp _build/$@ .

%.rml.native: FORCE
	rm -f $@
	$(RPMLBUILD) -no-links $@
	cp _build/$@ .

clean:
	rm domain_example_gen.*
	rm -rf _build
	rm -f *.byte *.native

FORCE:
