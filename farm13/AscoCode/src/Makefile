RMLBUILD=rmlbuild -classic-display -tag annot

TARGET=byte

all: asco.rml.$(TARGET) piano_phase.rml.$(TARGET) lib

asco.rml.$(TARGET):
	$(RMLBUILD) $@
	cp _build/$@ ..

piano_phase.rml.$(TARGET):
	$(RMLBUILD) $@
	cp _build/$@ ..

# Ascolib
lib: ascolib.cmo parser.cmo caml_queue.cmo caml_map.cmo
	ocamlc -c -I `rmlc -where`/toplevel a.ml
	ocamlc -a str.cma unix.cma \
		_build/types.cmo \
		_build/caml_queue.cmo _build/reactive_queue.cmo \
		_build/caml_map.cmo _build/reactive_map.cmo \
		_build/network.cmo _build/output.cmo \
		_build/utils.cmo _build/parser.cmo \
		_build/lexer.cmo \
		_build/time.cmo _build/input.cmo \
		_build/groups.cmo _build/motor.cmo \
		_build/ascolib.cmo a.cmo -o ascolib.cma
	rm *.cmo *.cmi
	cp _build/*.rzi _build/*.cmi ../lib
	mv ascolib.cma ../lib

.SUFFIXES: .rml .rmli .ml .mli .rzi .cmo .cmi

%.cmo:
	$(RMLBUILD) $@

clean:
	$(RMLBUILD) -clean
	rm -rf ../lib/*.rzi ../lib/*.cmi  ../lib/*.cma

cleanall: clean
	rm -rf *~
	rm -rf ../lib/*~

.PHONY: asco.rml.$(TARGET) clean cleanall
