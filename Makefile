ghc := ghc
ghcflags := -Wall -Werror

llvm_prefix ?= $(HOME)
prefix ?= $(HOME)
_lib := $(shell test -d /usr/lib64 && echo lib64 || echo lib)

ifeq ($(prefix),$(HOME))
user_flag := --user
endif

.PHONY: build
build: dist/setup-config
	./setup build

dist/setup-config: setup configure llvm.cabal llvm.buildinfo.in
	./setup configure --prefix=$(prefix) --libdir=$(prefix)/$(_lib) \
	    --configure-option --with-llvm-prefix=$(llvm_prefix) $(user_flag)

setup: Setup.lhs
	$(ghc) --make -O -o $@ $<

configure: configure.ac
	autoreconf

.PHONY: examples
examples:
	$(MAKE) -C examples

.PHONY: install
install: setup
	./setup install

clean:
	-./setup clean
	-rm -f setup Setup.hi Setup.o