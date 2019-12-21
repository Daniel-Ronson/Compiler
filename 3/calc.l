%{
#include "y.tab.h"
#include<string.h>
void yyerror (char *s);
int yylex();
%}
%%

"END."              return END;
VAR                 return VAR;
,                   return COMMA;
;                   return SEMICOLON;
:                   return COLON;
=                   return ASSIGNMENT;
"("                   return OPAREN;
")"                  return CPAREN;
"+"                 return PLUS;
"-"                 return MINUS;
"*"                 return TIMES;
"/"                 return DIVIDE;
PROGRAM             return PROGRAM;
INTEGER             return INTEGER;
BEGIN               return BEG;
PRINT               return PRINT;
[0-9]+              yylval.number=atoi(yytext);return DIGIT;
[a-f][a-f0-9]*      yylval.string=strdup(yytext);return IDENTIFIER;
'(\\.|[^\\'])*'     { 
                      int length = strlen(yytext); 
                      yytext[0] = '\"'; 
                      yytext[length - 1] = '\"'; 
                      yylval.string = strdup(yytext); 
                      return STRING;
                    }  

\n                  ;
[ \t]+              ;

%%
int yywrap (void) {return 1;}

