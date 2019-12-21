%{
void yyerror (char *s);
int yylex();
#include <stdio.h>     /* C declarations used in actions */
#include <stdlib.h>
#include <ctype.h>
#include<stack>
#include<string>
#include<iostream>
using namespace std;
  extern FILE *yyin;
	void write_to_file(char *str){
		FILE *c_code = fopen("code.cpp", "a");   
		fprintf(c_code,"%s ",str);
		fclose(c_code);
    }
	void write_to_file(int num){
		FILE *c_code = fopen("code.cpp", "a");   
		fprintf(c_code,"%d ",num);
		fclose(c_code);
    }
	void write_to_file_assignment(char *id, int num){
		FILE *c_code = fopen("code.cpp", "a");   
		fprintf(c_code,"%s = %d",id,num);
		fclose(c_code);	  
	}
stack<char*> s;
	void push_to_stack(char *str){
		  s.push(str);
		  //printf("%s\n",s.top());
	}
	void pop_from_stack(){
		int size = s.size();
		for (int i=0; i < size; i ++){
			//printf( "%s\n",s.top());
			write_to_file(s.top());
			s.pop();
		}
	}
	char* top_pop_from_stack(){
		char * str = s.top();
		s.pop();
		return str;
	}
	void clear_stack(){
		int size = s.size();
		for (int i=0; i < size; i ++){
			s.pop();
		}
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
start: PROGRAM pname semicolon var dec_list semicolon begin stat_list end { printf("C++ Generated Successfully \n"); }
    |   { yyerror((char*)"keyword 'PROGRAM' missing."); exit(1); }
    ;

pname: id  { printf("pname read\n"); };

id: IDENTIFIER { push_to_stack($1); printf("id read: [%s]\n", $1); };

var: VAR   { write_to_file((char*)"int main()\n {\n");
			 s.pop(); //pop of program name, which is an id
};

dec_list: dec colon type    { pop_from_stack(); };

dec:    IDENTIFIER comma dec    { push_to_stack((char*)","); push_to_stack($1);}
    |   IDENTIFIER   {  push_to_stack($1); };

semicolon: SEMICOLON   { write_to_file((char*)";\n"); };

colon: COLON   { printf("colon read\n"); }
    |   { yyerror((char*)"colon ':' missing."); exit(1); };



type: INTEGER   { push_to_stack((char*)"int"); } ;

begin: BEG  { printf("BEGIN read\n"); }
    |   { yyerror((char*)"keyword 'BEGIN' missing."); exit(1); }
    ;

stat_list: stat semicolon   { //printf("stat ; read\n"); 
}
    | stat semicolon stat_list  { //printf("stat_list read\n");
     }
    ;

stat:  print     { printf("stat read\n"); }
    |  assign    { //printf("assign returning); 
    }
    ;

print:   out oparen output cparen   { printf("PRINTING\n");}
    ;
    
out : PRINT { write_to_file((char*)"cout << ");};

oparen: OPAREN { //printf("open paren returning\n"); 
}
    |   { yyerror((char*)"open '(' missing."); exit(1); }
    ;

cparen: CPAREN { //printf("close paren read\n"); 
}
    |   { yyerror((char*)"closed parenthesis ')' missing."); //exit(1); 
    }
    
    ;


output: STRING comma id  {  write_to_file((char*)$1); 
							write_to_file((char*)"<<");
							write_to_file((char*)$3); 
					     }
    |   id { write_to_file((char*)$$);
				printf("output id returning\n"); }
    ;

comma: COMMA { printf("comma returning\n"); }
    |   { yyerror((char*)"',' expected."); exit(1); }
    ;

assign: id assignment expr { //pop_from_stack(); //clear_stack();
								//printf("assign returning $1=%s $3=%d\n",$1,$3); $$ = $3;
								//push_to_stack();
								}
    |   { yyerror((char*)"something went wrong during assignment."); exit(1); }
    ;

assignment: ASSIGNMENT { 
						write_to_file(top_pop_from_stack());
						write_to_file((char*)" = ");
						clear_stack();
						//printf("assignment returning\n");
						};

expr:  term         { //printf("expr term returning\n");
}
    | expr plus term { //printf("expr + term returning\n"); //$$ = $1 + $3;
    }
    
    | expr minus term { //printf("expr - term returning\n"); 
    };
					  

term:   term times factor { //printf("term * factor returning\n");// $$ = $1 * $3;
  }
    |   term divide factor {// printf("term / factor returning\n");
						
					  }
    |   factor          { //printf("factor returning\n");
    }
    ;
    
plus: PLUS	{write_to_file((char*)" + ");};
minus: MINUS	{write_to_file((char*)" - ");};
times: TIMES	{write_to_file((char*)" * ");};
divide: DIVIDE	{write_to_file((char*)" / ");};

factor: id          { printf("factor id returning\n"); write_to_file($1);
}
    |   number      { printf("factor number returning\n"); write_to_file($$);
    }
    |   '(' expr ')'{ printf("( expr ) IDK\n");  }
    ;

number: DIGIT   { printf("number DIGIT returning\n");//write_to_file($1); 
}
    ;

end: END { printf("END of Program.\n");write_to_file((char*)"return 0;\n}"); }
    |   { yyerror((char*)"keyword 'END.' expected."); exit(1); }
    ;

%%                     /* C code */

int main () {

    FILE *c_code = fopen("code.cpp", "a");   
    fprintf(c_code, "#include <iostream>\n using namespace std");
    fclose(c_code);
    
    yyin = fopen("output.txt","r");
	// Parse through the input:
	yyparse();
	fclose(yyin);
}

void yyerror (char *s) {fprintf (stderr, (char*)"%s\n", s);} 

