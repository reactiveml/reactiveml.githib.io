include ../../config

.PHONY: clean FORCE

all: pre_simple.rml.native pre_when_ok.rml.native pre_when_bad.rml.native\
	pre_when_domain.rml.native domain_pre.rml.native domain_pre_bad.rml.native

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
