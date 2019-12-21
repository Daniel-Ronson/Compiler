yacc -d calc.y
lex calc.l
g++ y.tab.c lex.yy.c -lfl -o calc