OCAML_VERSION=`ocamlc -version`
RML_VERSION=`rmlc -version`
DATE=`date "+%Y-%m-%d"`
SRC2HTML=./bin/src2html $(OCAML_VERSION) $(RML_VERSION) $(DATE)
BIBTEX2HTML=bibtex2html

GENERATED=index.html \
	documentation.html \
	examples.html \
	videos.html \
	publications.html \
	contact.html \
	tryrml/tryrml.html \
	examples/physics/index.html \
	examples/cellular_automata/index.html \
	examples/simulator_elip/index.html \
	publications/header.html \
	publications/footer.html \
	publications/index.html \
	rmltop/index.html \
	distrib/index.html \
	navigation.html \
	reactive_asco/index.html \
	reactive_asco/videos.html \
	reactive_asco/source.html \
	reactive_asco/code/types.html \
	reactive_asco/code/time.html \
	reactive_asco/code/motor.html \
	reactive_asco/code/groups.html \
	reactive_asco/code/input.html \
	reactive_asco/code/output.html \
	reactive_asco/code/syntax.html \
	reactive_asco/code/jacques.html

all: $(GENERATED)

.PHONY: $(GENERATED)

index.html: header.html footer.html index.src.html
	$(SRC2HTML) "." "ReactiveML" "Home" \
		header.html footer.html index.src.html > $@

documentation.html: header.html footer.html documentation.src.html
	$(SRC2HTML) "." "ReactiveML - Documentation" "Documentation" \
		header.html footer.html documentation.src.html > $@

examples.html: header.html footer.html examples.src.html
	$(SRC2HTML) "." "ReactiveML - Examples" "Examples" \
		header.html footer.html examples.src.html > $@

videos.html: header.html footer.html videos.src.html
	$(SRC2HTML) "." "ReactiveML - Videos" "Videos" \
		header.html footer.html videos.src.html > $@

publications.html: header.html footer.html publications.src.html
	$(SRC2HTML) "." "ReactiveML - Publications" "Publications" \
		header.html footer.html publications.src.html > $@

contact.html: header.html footer.html contact.src.html
	$(SRC2HTML) "." "ReactiveML - Contact" "Contact" \
		header.html footer.html contact.src.html > $@

tryrml/tryrml.html: header.html tryrml/tryrml.src.html
	$(SRC2HTML) ".." "ReactiveML - Try online" "Try online" \
		header.html tryrml/footer.html tryrml/tryrml.src.html > $@


examples/physics/index.html: header.html footer.html examples/physics/index.src.html
	$(SRC2HTML) "../.." "ReactiveML - Example" "XXX" header.html footer.html \
		examples/physics/index.src.html > $@

examples/cellular_automata/index.html: header.html footer.html examples/cellular_automata/index.src.html
	$(SRC2HTML) "../.." "ReactiveML - Example" "XXX" \
		header.html footer.html examples/cellular_automata/index.src.html > $@

examples/simulator_elip/index.html: header.html footer.html examples/simulator_elip/index.src.html
	$(SRC2HTML) "../.." "ReactiveML - Example" "XXX" \
		header.html footer.html examples/simulator_elip/index.src.html > $@


reactive_asco/index.html: header.html footer.html reactive_asco/index.src.html
	$(SRC2HTML) ".." "ReactiveML - Reactive Asco" "XXX" \
		header.html footer.html reactive_asco/index.src.html > $@

reactive_asco/videos.html: header.html footer.html reactive_asco/videos.src.html
	$(SRC2HTML) ".." "ReactiveML - Reactive Asco" "XXX" \
		header.html footer.html reactive_asco/videos.src.html > $@

reactive_asco/source.html: header.html footer.html reactive_asco/source.src.html
	$(SRC2HTML) ".." "ReactiveML - Reactive Asco" "XXX" \
		header.html footer.html reactive_asco/source.src.html > $@

reactive_asco/code/types.html: reactive_asco/code/types.src.html
	$(SRC2HTML) "../.." "ReactiveML - Reactive Asco" "XXX" \
		reactive_asco/code/header.html footer.html reactive_asco/code/types.src.html > $@

reactive_asco/code/time.html: reactive_asco/code/time.src.html
	$(SRC2HTML) "../.." "ReactiveML - Reactive Asco" "XXX" \
		reactive_asco/code/header.html footer.html reactive_asco/code/time.src.html > $@

reactive_asco/code/motor.html: reactive_asco/code/motor.src.html
	$(SRC2HTML) "../.." "ReactiveML - Reactive Asco" "XXX" \
		reactive_asco/code/header.html footer.html reactive_asco/code/motor.src.html > $@

reactive_asco/code/groups.html: reactive_asco/code/groups.src.html
	$(SRC2HTML) "../.." "ReactiveML - Reactive Asco" "XXX" \
		reactive_asco/code/header.html footer.html reactive_asco/code/groups.src.html > $@

reactive_asco/code/input.html: reactive_asco/code/input.src.html
	$(SRC2HTML) "../.." "ReactiveML - Reactive Asco" "XXX" \
		reactive_asco/code/header.html footer.html reactive_asco/code/input.src.html > $@

reactive_asco/code/output.html: reactive_asco/code/output.src.html
	$(SRC2HTML) "../.." "ReactiveML - Reactive Asco" "XXX" \
		reactive_asco/code/header.html footer.html reactive_asco/code/output.src.html > $@

reactive_asco/code/syntax.html: reactive_asco/code/syntax.src.html
	$(SRC2HTML) "../.." "ReactiveML - Reactive Asco" "XXX" \
		reactive_asco/code/header.html footer.html reactive_asco/code/syntax.src.html > $@

reactive_asco/code/jacques.html: reactive_asco/code/jacques.src.html
	$(SRC2HTML) "../.." "ReactiveML - Reactive Asco" "XXX" \
		header.html reactive_asco/code/footer.html reactive_asco/code/jacques.src.html > $@

publications/rml.html: publications/rml.bib
	(cd publications; \
	 $(BIBTEX2HTML) \
		-linebreak -noheader -nofooter \
		-nf url2 extended.pdf -nf webpage "more details" \
		 rml.bib)


publications/header.html: header.html publications/header.src.html
	cat header.html publications/header.src.html > $@

publications/footer.html: footer.html publications/footer.src.html
	cat publications/footer.src.html footer.html > $@

publications/index.html: publications/header.html publications/footer.html publications/rml.html
	$(SRC2HTML) ".." "ReactiveML - Publications" "XXX" \
		publications/header.html publications/footer.html \
		publications/index.src.html > $@

rmltop/index.html: header.html footer.html rmltop/index.src.html
	$(SRC2HTML) ".." "ReactiveML - Interactive Programming of Reactive Systems" "XXX" \
		header.html footer.html rmltop/index.src.html > $@

distrib/index.html: header.html footer.html distrib/index.src.html
	$(SRC2HTML) ".." "ReactiveML - Distribution" "XXX" \
		header.html footer.html distrib/index.src.html > $@


navigation.html: header.html footer.html navigation.src.html
	$(SRC2HTML) "." "ReactiveML - Navigation" "XXX" \
		header.html footer.html navigation.src.html > $@

clean:
	rm -f $(GENERATED) publications/rml.html publications/rml_bib.html

cleanall: clean
	rm -f *~ */*~ */*/*~ */*/*/*~
