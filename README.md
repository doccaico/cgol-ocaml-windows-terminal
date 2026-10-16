## cgol-ocaml
Windows (CMD.EXE) Only.

### Ocaml's Version
```
$ ocaml --version
The OCaml toplevel, version 5.4.1
```

### Run
```
$ ocaml -I +unix unix.cma main.ml
```

### Build an executable and reducing its size
```
$ ocamlopt -I +unix unix.cmxa -O2 -o main.exe main.ml
$ x86_64-w64-mingw32-strip.exe main.exe
```
