include ../../config

.PHONY: clean FORCE

all: radio.rml.native radio_agent.rml.native\
	radio_energy.rml.native radio_refine.rml.native

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
