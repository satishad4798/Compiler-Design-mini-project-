 ALGORITHM:

Step1: Start the program

Step2: Reading an expression

Step3: Checking the validating of the given expression according to the rule using yacc. 

Step4: Using expression rule print the result of the given values

Step5: Stop the program

PROGRAM CODE:

//Program to recognize a valid variable

LEX PART:

%{

    #include "y.tab.h"

%}

%%

[a-zA-Z_][a-zA-Z_0-9]* return letter;

[0-9]                       return digit;

.                      return yytext[0];

\n                     return 0;

%%

int yywrap()

{

return 1;

}

YACC PART:

%{

    #include<stdio.h>

    int valid=1;

%}

%token digit letter

%%

start : letter s

s :     letter s

      | digit s

      |

      ;

%%

int yyerror()

{

    printf("\nIts not a identifier!\n");

    valid=0;

    return 0;

}

int main()

{

    printf("\nEnter a name to tested for identifier ");

    yyparse();

    if(valid)

    {

        printf("\nIt is a identifier!\n");

    }

}