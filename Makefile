SHELL := /bin/bash -l
PBS_ACCOUNT ?= SCSG0001

veros-env: create_veros_environment.sh
	[ -d $@ ] && mv $@ $@.tmp && rm -rf $@.tmp &
	./$<

derecho-%.py: %.py derecho_jax_multigpu_init.py Makefile
	rm -f $@
	cp $< $@
	lineno=$$(grep -n "# -- end of auto-generated header" $< | cut -d: -f1) ;\
	sed -i "$${lineno}r derecho_jax_multigpu_init.py" $@
