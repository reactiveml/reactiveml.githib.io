RMLC=rmlc
RMLFLAGS=-dtypes -dreactivity -i
MAIN=main

OCAMLC=ocamlc
OCAMLFLAGS=

OCAMLOPT=ocamlopt
OCAMLOPTFLAGS=

SOURCES=first_program.rml \
	first_program_ok.rml \
	par_map.rml \
	imprecise.rml \
	server.rml \
	par_comb.rml \
	if_comb.rml \
	good_rec.rml \
	bad_rec.rml \
	row.rml \
	alias.rml \
	higher_order.rml \
	fix.rml \
	landin.rml \
	false_warning.rml \
	instantaneous.rml \


TARGETS=$(SOURCES:.rml=.byte)
TARGETSOPT=$(SOURCES:.rml=.opt)

all: byte
byte: $(TARGETS)
opt: $(TARGETSOPT)


# implicit rules
.SUFFIXES: .rml .mli .ml .cmi .cmo .cmx .o .rzi .byte .opt

.rml.ml:
	$(RMLC) $(RMLFLAGS) -s $(MAIN) $<

.ml.cmo:
	$(OCAMLC) $(OCAMLFLAGS) -c -I `$(RMLC) -where` $<

.mli.cmi:
	$(OCAMLC) $(OCAMLFLAGS) -c -I `$(RMLC) -where` $<

.ml.cmx:
	$(OCAMLOPT) $(OCAMLOPTFLAGS) -c -I `$(RMLC) -where` $<

.ml.o:
	$(OCAMLOPT) $(OCAMLOPTFLAGS) -c -I `$(RMLC) -where` $<

.mli.rzi:
	$(RMLC) -c $<

.cmo.byte:
	$(OCAMLC) $(OCAMLFLAGS) -o $@ unix.cma -I `$(RMLC) -where` rmllib.cma $<

.cmx.opt:
	$(OCAMLOPT) $(OCAMLOPTFLAGS) -o $@ unix.cmxa -I `$(RMLC) -where` rmllib.cmxa $<

clean :
	rm -f *.cm* *.o *.*annot *.rzi \
		$(SOURCES:.rml=.ml) $(TARGETS) $(TARGETSOPT)

cleanall: clean
	rm -f *~
