Project Descrtiption: Compiler with Lex Yacc 

q1. Removes whitespace and comments from source code of the language we were given.
q2. Checks source code for errors, so that the user can fix the error.
q3. C++ Code Generation from CFG language 

CFG Rules:
<start> -> PROGRAM<pname>; VAR ,dec-list>; BEGIN <stat-list> END.
<pname>     -> <id>
<id>        -> <letter>{<letter>|<digit>}
<dec-list>  -> <dec> : <type>
<dec>       -> <id>, <dec> | <id>

<stat-list> -> <stat>; | <stat>; <stat-list>
<stat>      -> <print> | <assign>
<print>     -> PRINT (<output>)
<output>    -> [“string”,} <id>
<assign>    -> <id> = <expr>

<expr>      -> <term> | <expr> + <term> | <expr> - <term>
<term>      -> <term> * <factor> | <term> / <factor> | <factor>
<factor>    -> <id> | <number> | <( <expr> )
<number>    -> <digit>{<digit>}
<type>      -> INTEGER
<digit>     -> 0|1|2|…|9
<letter>    -> a|b|c|d|e|f


How to Compile: use linux terminal

q1:
1. make all 
2. ./parse
input: myfile.txt
output: output.txt is created 

q2. 
1. ./compile_lex_yacc.sh
2. ./calc
output on terminal indicates if syntax errors exist.  The user can manually fix the syntax errors.

q3. reads from output.txt and creates code.cpp
1. ./compile_lex_yacc.sh
2. ./calc
3. g++ code.cpp
4. ./a.out 







