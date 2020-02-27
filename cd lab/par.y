%{
	void yyerror(char* s);
	int yylex();
	#include "stdio.h"
	#include "stdlib.h"
	#include "ctype.h"
	#include "string.h"
	void ins();
	void insV();
	int flag=0;

	

	extern char curid[20];
	extern char curtype[20];
	extern char curval[20];

%}

%nonassoc IF
%token INT CHAR FLOAT DOUBLE LONG SHORT SIGNED UNSIGNED STRUCT
%token RETURN MAIN
%token VOID
%token WHILE FOR DO 
%token BREAK
%token ENDIF
%expect 1

%token identifier
%token integer_constant string_constant float_constant character_constant

%nonassoc ELSE

%right leftshift_assignment_operator rightshift_assignment_operator
%right XOR_assignment_operator OR_assignment_operator
%right AND_assignment_operator modulo_assignment_operator
%right multiplication_assignment_operator division_assignment_operator
%right addition_assignment_operator subtraction_assignment_operator
%right assignment_operator

%left OR_operator
%left AND_operator
%left pipe_operator
%left caret_operator
%left amp_operator
%left equality_operator inequality_operator
%left lessthan_assignment_operator lessthan_operator greaterthan_assignment_operator greaterthan_operator
%left leftshift_operator rightshift_operator 
%left add_operator subtract_operator
%left multiplication_operator division_operator modulo_operator

%right SIZEOF
%right tilde_operator exclamation_operator
%left increment_operator decrement_operator 


%start program

%%
program
			: declaration_list;

declaration_list
			: declaration D 

D
			: declaration_list
			| ;

declaration
			: variable_declaration ;
			| function_declaration
		




variable_declaration
			: type_specifier variable_declaration_list ';' ;
		//	| structure_declaration;

variable_declaration_list
			: variable_declaration_identifier V;

V
			: ',' variable_declaration_list 
			| ;


variable_declaration_identifier 
			: identifier 
            |identifier assignment_operator integer_constant ;





type_specifier 
			: INT | CHAR | FLOAT | DOUBLE 
			| LONG 
			| SHORT 
			| UNSIGNED 
			| SIGNED 
			| VOID ;

expression 
			: identifier expression_breakup                                                      // num ( + |% - ) num
			| simple_expression	      
			 | identifier;

simple_expression :
                  identifier '<' identifier
                  | identifier '>' identifier | integer_constant;
expression_breakup
			: assignment_operator expression 
			| addition_assignment_operator expression 
			| subtraction_assignment_operator expression 
			| multiplication_assignment_operator expression 
			| division_assignment_operator expression | add_operator expression
			;

function_declaration
			: function_declaration_type function_declaration_param_statement;

function_declaration_type
			: type_specifier identifier '('                                      // int fun_name( { })
             | identifier '(' ;
function_declaration_param_statement
			: params ')' statement;                                                           // int fun_name(params)

params : type_specifier identifier ',' type_specifier identifier
        |
        ;

statement 
			: expression_statment | compound_statement 
			| conditional_statements | iterative_statements |return_statement
			| variable_declaration;

return_statement 
			: RETURN return_statement_breakup;

return_statement_breakup
			: ';' 
			| expression ';' ;     

compound_statement 
			: '{' statment_list '}' ;

statment_list 
			: statement statment_list 
			| ;

expression_statment 
			: expression ';' 
			| ';' ;



conditional_statements 
			: IF '(' simple_expression ')' statement conditional_statements_breakup;

conditional_statements_breakup
			: ELSE statement                                                                // if()  else()
			| ;                                                                            //optional else

iterative_statements 
			: WHILE '(' simple_expression ')' statement                                      //while loop
			| FOR '(' expression ';' simple_expression ';' expression ')' 
			| DO statement WHILE '(' simple_expression ')' ';';



%%

extern FILE *yyin;
extern int yylineno;
extern char *yytext;
void insertSTtype(char *,char *);
void insertSTvalue(char *, char *);
void incertCT(char *, char *);
void printST();
void printCT();

int main(int argc , char **argv)
{
	yyin = fopen(argv[1], "r");
	yyparse();

	if(flag == 0)
	{
		printf("\n\n---------------SYMBOL TABLE-----------------"  "\n\n", " ");
		printST();

		printf("\n\n---------------CONSTANT TABLE---------------"  "\n\n", " ");
		printCT();
	}
}

void yyerror(char *s)
{
	printf("syntax error on line %d .\n", yylineno);
	flag=1;
}


int yywrap()
{
	return 1;
}