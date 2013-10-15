include ../../config

.PHONY: clean FORCE

all: hello_world_ck.rml.native hello_world_seq.rml.native\
	stutter.rml.native stutter_nested.rml.native stutter_clock.rml.native\
	sum_ck.rml.native emit_slow.rml.native slow_signal.rml.native slow_signal_clock.rml.native\
	levelorder_ck.rml.native timer.rml.native timer_ok.rml.native quiet_sustain.rml.native\
	noisy_newline.rml.native memory_reset.rml.native levelorder_inst.rml.native\
	instantaneous.rml.native nonreactive_domain.rml.native auto_waiting.rml.native

%.rml.byte: FORCE
	rm -f $@
	$(RPMLBUILD) -no-links $@
	cp _build/$@ .

%.rml.d.byte: FORCE
	rm -f $@
	$(RPMLBUILD) -no-links $@
	cp _build/$@ .

%.rml.native: FORCE
	rm -f $@
	$(RPMLBUILD) -no-links $@
	cp _build/$@ .

clean:
	rm -rf _build
	rm -f *.byte *.native

FORCE:
