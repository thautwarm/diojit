package = dynjit
srcdir = lib
testdir = test
appdir = bin

builddir = caml-build
pythonlib = python3.8
objext = $(shell python cmds.py objext)
cc = gcc
ofile = __objdeps.$(objext)

src_mlfiles = $(wildcard $(srcdir)/*.ml)
src_cmifiles = $(patsubst %.ml,%.cmi,$(src_mlfiles))
src_cmxfiles = $(patsubst %.ml,%.cmx,$(src_mlfiles))
src_cfiles = $(wildcard $(srcdir)/*.c)
src_ofiles = $(wildcard $(srcdir)/*.$(objext))

app_mlfiles = $(wildcard $(appdir)/*.ml)
app_cmofiles = $(patsubst %.ml,%.cmo,$(app_mlfiles))

test_mlfiles = $(wildcard $(testdir)/*.ml)
test_cmofiles = $(patsubst %.ml,%.cmo,$(test_mlfiles))

local-install: $(srcdir)
	opam uninstall dynjit
	opam install .

plugin: local-install
	ocamlfind ocamlopt -shared -thread -o test/ddd.cmxs -linkpkg -package dynjit test/plugin.ml

.PHONY: clean
clean:
	rm -rf $(builddir)
	python cmds.py find $(srcdir) ".*(\.(ml|c|merlin)|dune)$$" --neg --action "ISDIR or os.remove(_)"
	python cmds.py find $(testdir) ".*(\.(ml|c|merlin)|dune)$$" --neg --action "ISDIR or os.remove(_)"
	python cmds.py find $(appdir) ".*(\.(ml|c|merlin)|dune)$$" --neg --action "ISDIR or os.remove(_)"
