SRC2HTML=./bin/src2html
BIBTEX2HTML=bibtex2html

GENERATED=index.html \
	documentation.html \
	examples.html \
	videos.html \
	publications.html \
	contacts.html \
	examples/physics/index.html \
	examples/cellular_automata/index.html \
	examples/simulator_elip/index.html \
	publications/index.html


all: $(GENERATED)

index.html: header.html footer.html index.src.html
	$(SRC2HTML) "." "ReactiveML" "Home" index.src.html > $@

documentation.html: header.html footer.html documentation.src.html
	$(SRC2HTML) "." "ReactiveML Documentation" "Documentation" documentation.src.html > $@

examples.html: header.html footer.html examples.src.html
	$(SRC2HTML) "." "ReactiveML Examples" "Examples" examples.src.html > $@

videos.html: header.html footer.html videos.src.html
	$(SRC2HTML) "." "ReactiveML Videos" "Videos" videos.src.html > $@

publications.html: header.html footer.html publications.src.html
	$(SRC2HTML) "." "ReactiveML Publications" "Publications" publications.src.html > $@

contacts.html: header.html footer.html contacts.src.html
	$(SRC2HTML) "." "ReactiveML Contacts" "Contacts" contacts.src.html > $@


examples/physics/index.html: header.html footer.html examples/physics/index.src.html
	$(SRC2HTML) "../.." "ReactiveML Example" "XXX" examples/physics/index.src.html > $@

examples/cellular_automata/index.html: header.html footer.html examples/cellular_automata/index.src.html
	$(SRC2HTML) "../.." "ReactiveML Example" "XXX" examples/cellular_automata/index.src.html > $@

examples/simulator_elip/index.html: header.html footer.html examples/simulator_elip/index.src.html
	$(SRC2HTML) "../.." "ReactiveML Example" "XXX" examples/simulator_elip/index.src.html > $@

publications/rml.html: publications/rml.bib
	$(BIBTEX2HTML) -o publications/rml \
		-linebreak -revkeys -noheader -nofooter \
		-nf url2 extended.pdf -nf webpage "more details" \
		 publications/rml.bib

publications/index.html: header.html footer.html publications/rml.html
	$(SRC2HTML) ".." "ReactiveML Publications" "XXX" publications/index.src.html > $@


clean:

cleanall: clean
	rm -f $(GENERATED) publications/rml.html publications/rml_bib.html \
		*~ */*~ */*/*~ */*/*/*~
