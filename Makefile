SHELL := /bin/bash -l
PBS_ACCOUNT ?= SCSG0001

# Get the directory of the Makefile
MAKEFILE_DIR := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))

all: veros-env veros-tests

veros-env: create_veros_environment.sh
	[ -d $@ ] && mv $@ $@.tmp && rm -rf $@.tmp &
	./$<

veros-tests: create_veros_examples.sh
	[ -d $@ ] && mv $@ $@.tmp && rm -rf $@.tmp &
	./$<

# insert Derecho-specific configuration at the beginning of a Veros example.
derecho_%.py: %.py $(MAKEFILE_DIR)/derecho_jax_multigpu_init.py $(MAKEFILE_LIST)
	rm -f $@
	cp $< $@
	lineno=$$(grep -n "# -- end of auto-generated header" $< | cut -d: -f1) ;\
	[ -z "$${lineno}" ] || sed -i "$${lineno}r $(MAKEFILE_DIR)/derecho_jax_multigpu_init.py" $@


clobber:
	git clean -xdf .
