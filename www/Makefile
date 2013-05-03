SRC2HTML=./bin/src2html

GENERATED=index.html \
	documentation.html \
	examples.html \
	videos.html \
	publications.html \
	contacts.html

all: $(GENERATED)

index.html: header.html footer.html index.src.html
	$(SRC2HTML) "." "ReactiveML" "ReactiveML" index.src.html > $@

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



clean:

cleanall: clean
	rm -f $(GENERATED) *~ */*~
