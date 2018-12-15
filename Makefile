.PHONY: default build install uninstall test clean

default: build

dep:
	opam install -y ffmpeg

build:
	dune build src/camstreamer.exe

dbg:
	dune build src/camstreamer.bc
	cp ./_build/default/src/camstreamer.bc .

test:
	dune runtest -f

exec:
	dune exec src/camstreamer.exe

install:
	dune install

uninstall:
	dune uninstall

clean:
	dune clean
# Optionally, remove all files/folders ignored by git as defined
# in .gitignore (-X).
#git clean -dfXq
