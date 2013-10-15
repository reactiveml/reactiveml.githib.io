include ../../config

.PHONY: clean FORCE

all: bank1.rml.native bank1_memory.rml.native bank2.rml.native bank3_wrong.rml.native\
	bank3_fixed.rml.native bank3_ref.rml.native bank3_domain.rml.native\
	bank4.rml.native

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
	rm -rf _build
	rm -f *.byte *.native

FORCE:
