RMLBUILD=rmlbuild -classic-display -tag annot

TARGET=native

all: asco.rml.$(TARGET) piano_phase.rml.$(TARGET) lib

asco.rml.$(TARGET):
	$(RMLBUILD) $@
	cp _build/$@ ..

piano_phase.rml.$(TARGET):
	$(RMLBUILD) $@
	cp _build/$@ ..

# Ascolive
lib: ascolive.cmo parser.cmo
	ocamlc -c -I `rmlc -where`/toplevel a.ml
	ocamlc -a str.cma unix.cma \
		_build/types.cmo _build/rqueue.cmo \
		_build/network.cmo _build/output.cmo \
		_build/utils.cmo _build/parser.cmo \
		_build/lexer.cmo \
		_build/time.cmo _build/input.cmo \
		_build/groups.cmo _build/motor.cmo \
		_build/ascolive.cmo a.cmo -o ascolive.cma
	rm *.cmo *.cmi
	cp _build/*.rzi _build/*.cmi ../lib
	mv ascolive.cma ../lib

parser.cmo:
	$(RMLBUILD) $@

ascolive.cmo:
	$(RMLBUILD) $@

clean:
	$(RMLBUILD) -clean
	rm -rf ../lib/*.rzi ../lib/*.cmi  ../lib/*.cma

cleanall: clean
	rm -rf *~
	rm -rf ../lib/*~

.PHONY: asco.rml.$(TARGET) clean cleanall
