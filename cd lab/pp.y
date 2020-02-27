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
%expect 2

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
			: variable_declaration 
			| function_declaration
			| structure_definition;

variable_declaration
			: type_specifier variable_declaration_list ';' 
			| structure_declaration;

variable_declaration_list
			: variable_declaration_identifier V;

V
			: ',' variable_declaration_list 
			| ;

variable_declaration_identifier 
			: identifier { ins(); } vdi;

vdi : identifier_array_type | assignment_operator expression ; 

identifier_array_type
			: '[' initilization_params
			| ;

initilization_params
			: integer_constant ']' initilization
			| ']' string_initilization;

initilization
			: string_initilization
			| array_initialization
			| ;

type_specifier 
			: INT | CHAR | FLOAT | DOUBLE 
			| LONG long_grammar 
			| SHORT short_grammar
			| UNSIGNED unsigned_grammar 
			| SIGNED signed_grammar
			| VOID ;

unsigned_grammar 
			: INT | LONG long_grammar | SHORT short_grammar | ;

signed_grammar 
			: INT | LONG long_grammar | SHORT short_grammar | ;

long_grammar 
			: INT | ;

short_grammar 
			: INT | ;

structure_definition
			: STRUCT identifier { ins(); } '{' V1  '}' ';';

V1 : variable_declaration V1 | ;

structure_declaration 
			: STRUCT identifier variable_declaration_list;


function_declaration
			: function_declaration_type function_declaration_param_statement;

function_declaration_type
			: type_specifier identifier '('  { ins();};                                        // int fun_name( { })

function_declaration_param_statement
			: params ')' statement;                                                           // int fun_name(params)

params 
			: parameters_list | ;

parameters_list 
			: type_specifier parameters_identifier_list;                                        // int fun_name( int num)

parameters_identifier_list 
			: param_identifier parameters_identifier_list_breakup;

parameters_identifier_list_breakup
			: ',' parameters_list 
			| ;                                                                                  //int fun_name( int num,int num2)

param_identifier 
			: identifier { ins(); } param_identifier_breakup;

param_identifier_breakup
			: '[' ']'
			| ;

statement 
			: expression_statment | compound_statement 
			| conditional_statements | iterative_statements 
			| return_statement | break_statement 
			| variable_declaration;

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

return_statement 
			: RETURN return_statement_breakup;

return_statement_breakup
			: ';' 
			| expression ';' ;                                                                                //return a+b;

break_statement 
			: BREAK ';' ;

string_initilization
			: assignment_operator string_constant { insV(); };                                          // ="str";

array_initialization
			: assignment_operator '{' array_int_declarations '}';                                          //{1,2,3};

array_int_declarations
			: integer_constant array_int_declarations_breakup;

array_int_declarations_breakup
			: ',' array_int_declarations   
			| ;

// expression 
// 			: mutable expression_breakup                                                      // num ( + |% - ) num
// 			| simple_expression ;


expression 
			: mutable expression_breakup                                                      // num ( + |% - ) num
			| simple_expression
			|tilde_operator mutable                //not bitwise operator
	      
			 ;



expression_breakup
			: assignment_operator expression 
			| addition_assignment_operator expression 
			| subtraction_assignment_operator expression 
			| multiplication_assignment_operator expression 
			| division_assignment_operator expression 
			| modulo_assignment_operator expression 
			| increment_operator 
			| decrement_operator 
			| amp_operator expression 
			| pipe_operator expression
			| caret_operator expression  
			|rightshift_operator expression
			|leftshift_operator expression 
			;


simple_expression 
			: and_expression simple_expression_breakup;                           

simple_expression_breakup 
			: OR_operator and_expression simple_expression_breakup | ;

and_expression                                                                                            //  !         a<b
			: unary_relation_expression and_expression_breakup; 

and_expression_breakup
			: AND_operator unary_relation_expression and_expression_breakup
			| ;

unary_relation_expression                                                                                          //
			: exclamation_operator unary_relation_expression 
			| regular_expression ;

regular_expression                                                                  // (a+b)  (< | > | <= )  (a+b)
			: sum_expression regular_expression_breakup;      

regular_expression_breakup
			: relational_operators sum_expression 
			| ;

relational_operators 
			: greaterthan_assignment_operator | lessthan_assignment_operator | greaterthan_operator 
			| lessthan_operator | equality_operator | inequality_operator ;

sum_expression 
			: sum_expression sum_operators term                                        // number +(-) numner +number
			| term ;

sum_operators 
			: add_operator 
			| subtract_operator ;

term
			: term MULOP factor                                       // number (* / %) number * number
			| factor ;

MULOP 
			: multiplication_operator | division_operator | modulo_operator ;

factor 
			: immutable | mutable ;

mutable 
			: identifier                               
			| mutable mutable_breakup;

mutable_breakup
			: '[' expression ']'                                                         
			| '.' identifier;

immutable 
			: '(' expression ')' 
			| call | constant; 

call
		: identifier '(' arguments ')';

arguments 
			: arguments_list | ;

arguments_list 
			: expression A;

A
			: ',' expression A 
			| ;

constant 
			: integer_constant 	{ insV(); } 
			| string_constant	{ insV(); } 
			| float_constant	{ insV(); } 
			| character_constant{ insV(); };

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
		printf( "\n\n Program parsed successfully."  "\n");
		printf("\n\n---------------SYMBOL TABLE-----------------"  "\n\n", " ");
	//	printf("------------");
		printST();
		printf("\n\n---------------END OF SYMBOL TABLE-----------------"  "\n\n", " ");

		printf("\n\n---------------CONSTANT TABLE---------------"  "\n\n", " ");
	//	printf("%30s %s\n", " ", "--------------");
		printCT();
		printf("\n\n---------------END OF CONSTANT TABLE-----------------"  "\n\n", " ");
	}
}

void yyerror(char *s)
{
	printf("syntax error on line %d .\n", yylineno);
	flag=1;
}

void ins()
{
	insertSTtype(curid,curtype);
}

void insV()
{
	insertSTvalue(curid,curval);
}

int yywrap()
{
	return 1;
}