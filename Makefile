SRC2HTML=./bin/src2html
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
	emsoft13/index.html \
	emsoft13/videos.html \
	emsoft13/source.html \
	emsoft13/code/types.html \
	emsoft13/code/time.html \
	emsoft13/code/motor.html \
	emsoft13/code/groups.html \
	emsoft13/code/input.html \
	emsoft13/code/output.html

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


emsoft13/index.html: header.html footer.html emsoft13/index.src.html
	$(SRC2HTML) ".." "ReactiveML - Reactive Asco" "XXX" \
		header.html footer.html emsoft13/index.src.html > $@

emsoft13/videos.html: header.html footer.html emsoft13/videos.src.html
	$(SRC2HTML) ".." "ReactiveML - Reactive Asco" "XXX" \
		header.html footer.html emsoft13/videos.src.html > $@

emsoft13/source.html: header.html footer.html emsoft13/source.src.html
	$(SRC2HTML) ".." "ReactiveML - Reactive Asco" "XXX" \
		header.html footer.html emsoft13/source.src.html > $@

emsoft13/code/types.html: emsoft13/code/types.src.html
	$(SRC2HTML) "../.." "ReactiveML - Reactive Asco" "XXX" \
		emsoft13/code/header.html emsoft13/code/footer.html emsoft13/code/types.src.html > $@

emsoft13/code/time.html: emsoft13/code/time.src.html
	$(SRC2HTML) "../.." "ReactiveML - Reactive Asco" "XXX" \
		emsoft13/code/header.html emsoft13/code/footer.html emsoft13/code/time.src.html > $@

emsoft13/code/motor.html: emsoft13/code/motor.src.html
	$(SRC2HTML) "../.." "ReactiveML - Reactive Asco" "XXX" \
		emsoft13/code/header.html emsoft13/code/footer.html emsoft13/code/motor.src.html > $@

emsoft13/code/groups.html: emsoft13/code/groups.src.html
	$(SRC2HTML) "../.." "ReactiveML - Reactive Asco" "XXX" \
		emsoft13/code/header.html emsoft13/code/footer.html emsoft13/code/groups.src.html > $@

emsoft13/code/input.html: emsoft13/code/input.src.html
	$(SRC2HTML) "../.." "ReactiveML - Reactive Asco" "XXX" \
		emsoft13/code/header.html emsoft13/code/footer.html emsoft13/code/input.src.html > $@

emsoft13/code/output.html: emsoft13/code/output.src.html
	$(SRC2HTML) "../.." "ReactiveML - Reactive Asco" "XXX" \
		emsoft13/code/header.html emsoft13/code/footer.html emsoft13/code/output.src.html > $@


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

cleanall: clean
	rm -f $(GENERATED) publications/rml.html publications/rml_bib.html \
		*~ */*~ */*/*~ */*/*/*~
