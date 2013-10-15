include ../../config

.PHONY: clean FORCE

all: planets.rml.native planets_dyn.rml.native\
	planets_heun.rml.native planets_switch.rml.native

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
