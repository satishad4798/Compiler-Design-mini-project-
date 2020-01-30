%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>


//we have  used linked list
struct symbol
{
	char name[999];
	char type[999];
	struct symbol* next;
};
struct symbol* ST= NULL;

struct constant
{
	char name[999];
	char type[999];
	struct constant* next;
};
struct constant* CT = NULL;


int check_present_ST(char *str1){
		struct symbol* temp ;
		if(ST==NULL)
		return 0;
		else{
		temp=ST;
		while(temp!=NULL)
		{
			if(strcmp(temp->name,str1)==0)
			return 1;
			temp=temp->next;
		}
	}
		return 0;
}

void add_to_table_ST(char *str1, char *str2)
{
	if(check_present_ST(str1))
		return;
	else
	{
		struct symbol* temp;
		struct symbol* newnode = (struct symbol*)malloc(sizeof(struct symbol));
		strcpy(newnode->name,str1);
		strcpy(newnode->type,str2);
		newnode->next = NULL;
		if(ST==NULL)
			{
				ST=newnode;
			}
			else{			
				temp=ST;
				while(temp->next!=NULL)
				{
				temp=temp->next;
				}           
				temp->next=newnode;
			}
		}
}

int check_present_CT(char *str1){
		
		struct constant* temp;
		if(CT==NULL)
		return 0;
		else{
		temp=CT;

		while(temp!=NULL)
		{
			if(strcmp(temp->name,str1)==0)
			return 1;
			temp=temp->next;
		}
	}
		return 0;
}

void add_to_table_CT(char *str1, char *str2)
{
	if(check_present_CT(str1))
		return;
	else
	{
		struct constant* temp;
		struct constant* newnode = (struct constant*)malloc(sizeof(struct constant));
		strcpy(newnode->name ,str1);
		strcpy(newnode->type ,str2);
		newnode->next = NULL;
		if(CT==NULL)
			{
				CT=newnode;
			}
			else{			
				temp=CT;
				while(temp->next!=NULL)
				{
				temp=temp->next;
				}            
				temp->next=newnode;
			}	
	}		
}

void print_symbol_table(void){

	struct symbol* temp1=ST;
	printf("\n\n\t========Symbol Table===========\n");
	while(temp1!=NULL)
	{ 
		printf("\t%s\t-\t%s\n",temp1->name,temp1->type);
		temp1 = temp1->next;
	}

	struct constant* temp2 = (struct constant*)malloc(sizeof(struct constant));
	temp2=CT;
	printf("\n\n\t========Constant Table=========\n");
	while(temp2!=NULL)
	{
		printf("\t%s\t-\t%s\n",temp2->name,temp2->type);
		temp2= temp2->next;
	}
}



%}


keywords auto|break|case|char|const|continue|default|do|double|else|enum|extern|float|for|goto|if|int|long|register|return|short|signed|sizeof|static|struct|switch|typedef|union|unsigned|void|volatile|while|main
operator [[<][=]|[>][=]|[=][=]|[!][=]|[>]|[<]|[\|][\|]|[&][&]|[\!]|[=]|[\^]|[\+][=]|[\-][=]|[\*][=]|[\/][=]|[\%][=]|[\+][\+]|[\-][\-]|[\+]|[\-]|[\*]|[\/]|[\%]|[&]|[\|]|[~]|[<][<]|[>][>]]


%%
\n   {yylineno++;}
([#][" "]*(include)[ ]*([<])([A-Za-z]+)[.]?([A-Za-z]*)([>]))/["\n"|\/|" "|"\t"] {printf("\t%s \t-Preprocessor directive\n",yytext);}	//Matches #include<stdio.h>
([#][" "]*(define)[" "]*([A-Za-z]+)(" ")*[0-9]+)/["\n"|\/|" "|"\t"] {printf("\t%s \t-Macro\n",yytext);} //Matches macro
\/\/(.*) {printf("\t%s \t- Single line comment\n", yytext);}				
\/\*([^*]|[\r\n]|(\*+([^*/]|[\r\n])))*\*+\/  {printf("\t%s \t- Multi line comment\n", yytext);}
[ \n\t] ;
; {printf("\t%s \t- Semicolon \n", yytext);}
, {printf("\t%s \t- Comma \n", yytext);}
\{ {printf("\t%s \t- Opening braces\n", yytext);}
\} {printf("\t%s \t- Closing braces\n", yytext);}
\( {printf("\t%s \t- Opening brackets\n", yytext);}
\) {printf("\t%s \t- Closing brackets\n", yytext);}
\[ {printf("\t%s \t- Square opening brackets\n", yytext);}
\] {printf("\t%s \t- Square closing brackets\n", yytext);}
\: {printf("\t%s \t- Colon \n", yytext);}
\\ {printf("t\%s \t- Fslash\n", yytext);}
\. {printf("\t%s \t- Dot \n", yytext);}

{keywords}/[\(|" "|\{|;|:|"\n"|"\t"] {printf("\t%s \t- Keyword\n", yytext); add_to_table_ST(yytext, "Keyword");}
\"[^\n]*\"/[;|,|\)] {printf("\t%s \t- String constant\n", yytext); add_to_table_CT(yytext,"String Constant");}
\'[A-Z|a-z]\'/[;|,|\)|:] {printf("\t%s \t- Character constant\n", yytext); add_to_table_CT(yytext,"Character constant");}
[a-z|A-Z]([a-z|A-Z]|[0-9])*/\[ {printf("\t%s \t- Array identifier\n", yytext); add_to_table_ST(yytext, "Identifier");}

{operator}/[a-z]|[0-9]|;|" "|[A-Z]|\(|\"|\'|\)|\n|\t {printf("\t%s \t- Operator\n", yytext);} 

[1-9][0-9]*|0/[;|,|" "|\)|<|>|=|\!|\||&|\+|\-|\*|\/|\%|~|\]|\}|:|\n|\t|\^] {printf("\t%s \t- Number constant\n", yytext); add_to_table_CT(yytext, "Number constant");}
([0-9]*)\.([0-9]+)/[;|,|" "|\)|<|>|=|\!|\||&|\+|\-|\*|\/|\%|~|\n|\t|\^] {printf("\t%s \t- Floating constant\n", yytext); add_to_table_CT(yytext, "Floating constant");}
[A-Za-z_][A-Za-z_0-9]*/[" "|;|,|\(|\)|<|>|=|\!|\||&|\+|\-|\*|\/|\%|~|\n|\.|\{|\^|\t] {printf("\t%s \t- Identifier\n", yytext); add_to_table_ST(yytext, "Identifier");}


(.?) {	
	if(yytext[0]=='#')
		{
       		printf("Error in Pre-Processor directive at line no. %d\n",yylineno);
       	}
	else if(yytext[0]=='/')
	{
		printf("Err_unmatched_comment at line no. %d\n",yylineno);
	}
	else if(yytext[0]=='"')
	{
		printf("Err_incomplete_string at line no. %d\n",yylineno);
	}
	else
	{
		printf("Error at line no. %d\n",yylineno);
	}
	printf("%s\n", yytext);
	return 0;
}

%%

int main(int argc , char **argv){

printf("\t\t***Lexical Analyser***\n");

; //yyin = fopen("test1.c","r");
; yyin=fopen(argv[1],"r");

if (argc >= 2)
         yyin = fopen(argv[1], "r");
    else yyin = fopen("input.c", "r");


yylex();

print_symbol_table();
}

int yywrap(){
return 1;
}