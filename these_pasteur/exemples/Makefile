SUBDIRS=DoEsteRML annA cellular sensor EsteRML bank boids nbody ch1 ch2 ch3 ch4 ch6 ch7 ch8

.PHONY: all clean install

all:
	for d in $(SUBDIRS); do (cd $$d; $(MAKE)); done

install:

clean:
	for d in $(SUBDIRS); do (cd $$d; $(MAKE) clean); done