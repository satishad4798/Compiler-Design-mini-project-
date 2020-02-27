 YACC PROGRAM to recognize a valid variable, which starts with a letter followed by any number of letters or digits

program to recognize a valid variable, which starts with a letter followed by any number of letters or digits



4b.l file
%{
#include "y.tab.h"
%}
%%
[0-9]+ {return DIGIT;}
[a-zA-Z]+ {return LETTER;}
[ \t] {;}
\n { return 0;}
. {return yytext[0];}
%%



4b.y file


%{
#include<stdio.h>
%}
%token DIGIT LETTER
%%
stmt:A
     ;
A: LETTER B
 ;
B: LETTER B
 | DIGIT B
 | LETTER
 | DIGIT
 ;
%%
void main(){
printf("enter string \n");
yyparse();
printf("valid");
exit(0);
}
void yyerror()
{
printf("invalid");
exit(0);
}
