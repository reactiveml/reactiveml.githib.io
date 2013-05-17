RMLC=rmlc
OCAMLC=ocamlc

all: compile

compile: rmltop_stdlib.rmli rmltop_stdlib.rml
	$(RMLC) rmltop_stdlib.rmli
	$(RMLC) rmltop_stdlib.rml
	$(OCAMLC) -I `$(RMLC) -where` -c rmltop_stdlib.mli rmltop_stdlib.ml

clean:
	rm -f 	rmltop_stdlib.rzi \
		rmltop_stdlib.mli rmltop_stdlib.ml rmltop_stdlib.cm* 

realclean: clean
	rm -f *~
cleanall: realclean
