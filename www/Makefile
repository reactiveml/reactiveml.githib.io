SRC2HTML=./bin/src2html
BIBTEX2HTML=bibtex2html

GENERATED=index.html \
	documentation.html \
	examples.html \
	videos.html \
	publications.html \
	contacts.html \
	tryrml/tryrml.html \
	examples/physics/index.html \
	examples/cellular_automata/index.html \
	examples/simulator_elip/index.html \
	publications/index.html


all: $(GENERATED)

index.html: header.html footer.html index.src.html
	$(SRC2HTML) "." "ReactiveML" "Home" \
		header.html footer.html index.src.html > $@

documentation.html: header.html footer.html documentation.src.html
	$(SRC2HTML) "." "ReactiveML Documentation" "Documentation" \
		header.html footer.html documentation.src.html > $@

examples.html: header.html footer.html examples.src.html
	$(SRC2HTML) "." "ReactiveML Examples" "Examples" \
		header.html footer.html examples.src.html > $@

videos.html: header.html footer.html videos.src.html
	$(SRC2HTML) "." "ReactiveML Videos" "Videos" \
		header.html footer.html videos.src.html > $@

publications.html: header.html footer.html publications.src.html
	$(SRC2HTML) "." "ReactiveML Publications" "Publications" \
		header.html footer.html publications.src.html > $@

contacts.html: header.html footer.html contacts.src.html
	$(SRC2HTML) "." "ReactiveML Contacts" "Contacts" \
		header.html footer.html contacts.src.html > $@

tryrml/tryrml.html: header.html tryrml/tryrml.src.html
	$(SRC2HTML) ".." "ReactiveML TryRML" "TryRML" \
		header.html tryrml/footer.html tryrml/tryrml.src.html > $@


examples/physics/index.html: header.html footer.html examples/physics/index.src.html
	$(SRC2HTML) "../.." "ReactiveML Example" "XXX" header.html footer.html \
		examples/physics/index.src.html > $@

examples/cellular_automata/index.html: header.html footer.html examples/cellular_automata/index.src.html
	$(SRC2HTML) "../.." "ReactiveML Example" "XXX" \
		header.html footer.html examples/cellular_automata/index.src.html > $@

examples/simulator_elip/index.html: header.html footer.html examples/simulator_elip/index.src.html
	$(SRC2HTML) "../.." "ReactiveML Example" "XXX" \
		header.html footer.html examples/simulator_elip/index.src.html > $@

publications/rml.html: publications/rml.bib
	$(BIBTEX2HTML) -o publications/rml \
		-linebreak -noheader -nofooter \
		-nf url2 extended.pdf -nf webpage "more details" \
		 publications/rml.bib

publications/index.html: header.html footer.html publications/rml.html
	$(SRC2HTML) ".." "ReactiveML Publications" "XXX" header.html footer.html \
		publications/index.src.html > $@


clean:

cleanall: clean
	rm -f $(GENERATED) publications/rml.html publications/rml_bib.html \
		*~ */*~ */*/*~ */*/*/*~
