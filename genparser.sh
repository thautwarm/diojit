if [ "`uname`" = "Linux" ]
then
    eval $(opam env)
    ocamllex src/lexer.mll
    menhir src/parser.mly
else
    C://Windows//System32//bash.exe genparser.sh
fi