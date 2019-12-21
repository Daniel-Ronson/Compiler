%{
void yyerror (char *s);
int yylex();
#include <stdio.h>     /* C declarations used in actions */
#include <stdlib.h>
#include <ctype.h>
#include<stack>
#include<string>
#include<iostream>
#include<vector>
using namespace std;
  extern FILE *yyin;
  
stack<char*> s;
vector<string> arr;

	void push_to_stack(char *str){
		  string string_val(str);
		  arr.push_back(string_val);
		  printf("STACK TOP  -------   %s\n", str);
	}
	bool check_stack(char *str){
	
		string id_value(str);
		
		for(int i=0; i < arr.size(); i++){
					
			if ( arr[i] == id_value){ return true;}
						
			//s.pop();
		}
		return false;
	}
%}

%union {int number; char * string;}         /* Yacc definitions */
%token PROGRAM INTEGER END VAR COMMA SEMICOLON COLON BEG PRINT ASSIGNMENT
%token OPAREN CPAREN OPERATOR PLUS MINUS TIMES DIVIDE
%token <number> STATE DIGIT
%token <string> LETTER IDENTIFIER STRING
%type <string> pname id dec print output
%type <number> assign expr term factor
%locations
%%
start: PROGRAM pname semicolon var dec_list semicolon begin stat_list end { printf("No Errors\n"); }
    |   { yyerror((char*)"'PROGRAM' is Expected."); exit(1); }
    ;

pname: id  { printf("pname valid\n"); }
    |   { yyerror((char*)"program name <pname> Missing."); exit(1); }
    ;

id: IDENTIFIER { printf("id: [%s]\n", $1);}
    ;

var: VAR   { printf("var returning\n"); }
    |   { yyerror((char*)"'VAR' is Expected."); exit(1); }
    ;

dec_list: dec colon type    { printf("dec_list read\n"); }
    ;

dec:    IDENTIFIER comma dec    { printf("dec [%s]\n", $3);push_to_stack($3); push_to_stack($1);}
    |   IDENTIFIER IDENTIFIER   { yyerror((char*)"two consecutive identifiers found ',' is required."); exit(1); }
    |   IDENTIFIER   { printf("identifier returning [%s]\n", $1);//push_to_stack($1); 
    }
    ;

colon: COLON   { printf("colon\n"); }
    |   { yyerror((char*)"colon ':' expected."); exit(1); }
    ;

semicolon: SEMICOLON   { printf("semicolon read\n"); }
    |   { yyerror((char*)"semicolon ';' expected."); exit(1); }
    ;

type: INTEGER   { printf("integer read\n"); }
    |   { yyerror((char*)"keyword type of 'INTEGER' expected."); exit(1); }
    ;

begin: BEG  { printf("BEGIN\n"); }
    |   { yyerror((char*)"'BEGIN' is Expected."); exit(1); }
    ;

stat_list: stat semicolon   { printf("stat ; read\n"); }
    | stat semicolon stat_list  { printf("stat ; stat_list read \n"); }
    ;

stat:  print     { printf("stat read\n"); }
    |  assign    { printf("assign read value=%d\n",$1); }
    ;

print:   PRINT oparen output cparen   { printf("printing\n");}
    ;

oparen: OPAREN { printf("open parenthisis\n"); }
    |   { yyerror((char*)"open parenthesis '(' required."); exit(1); }
    ;

cparen: CPAREN { printf("close paren\n"); }
    |   { yyerror((char*)"closed parenthesis ')' required."); exit(1); }
    ;

output: id  { printf("output id \n"); }
    |   STRING comma id { printf("string , id \n"); }
    ;

comma: COMMA { printf("comma\n"); }
    |   { yyerror((char*)"',' expected."); exit(1); }
    ;

assign: id assignment expr { printf("assign returning %s = %d\n",$1,$3); $$ = $3; }
    |   { yyerror((char*)"something went wrong during assignment."); exit(1); }
    ;

assignment: ASSIGNMENT { printf("assignment here\n"); }
    |   { yyerror((char*)"assignment operator '=' expected."); exit(1); }
    ;

expr:  term           { printf("expr term\n"); }
    | expr PLUS term  { printf("expr + term\n"); $$ = $1 + $3; }
    | expr MINUS term { printf("expr - term\n"); }
    ;

term:   term TIMES factor  { printf("term * factor\n"); $$ = $1 * $3; }
    |   term DIVIDE factor { printf("term / factor\n"); }
    |   factor             { printf("factor \n"); }
    ;

factor: id          { if(check_stack($1) == true){ 
						printf("factor id HERE\n");
					  }
					  else {printf("error, identifier %s does not exist", $1); exit(1);}
						 }
    |   number      { printf("factor number \n"); }
    |   '(' expr ')'{ printf("( expr ) \n"); }
    ;

number: DIGIT   { printf("number DIGIT \n"); }
    ;

end: END { printf("END.\n"); }
    |   { yyerror((char*)"keyword 'END.' required."); exit(1); }
    ;

%%                     /* C code */


int main (void) {
  
  yyin = fopen("output.txt","r");

  // Parse through the input:
  
  yyparse();
  fclose(yyin);

  return 0;
}

void yyerror (char *s) {fprintf (stderr, "%s\n", s);} 

