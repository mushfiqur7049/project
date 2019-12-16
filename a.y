 %{
#include <stdio.h>
#include<stdlib.h>
#include<string.h>
extern FILE *yyin,*yyout;
int i,f=0;
typedef struct variable {
			char *str;
	    		int n;
			}array;
array a1[1000];
void variable (array *p, char *s, int n);
void value_assign (char *s, int n);
int count = 1,cnt = 1,sw=0;
int q=0,prev=0;
 %}



%union 
{
	 int number;
        char *string;
}

%token <string> VAR
%type <number> exp assig
%type <string> param if_conditions 
%token <number> NUM
%token MAIN IF ELSE ELIF TO FOR INT DOUBLE FLOAT CHAR DO WHILE HEADER ID VD LN TAN SIN COS UP UM GT GE LT LE MIN PLUS MUL DIV AND OR NOT EQ NQ CASE DEFAULT SWITCH LEFT_PARENTHESIS RIGHT_PARENTHESIS LEFT_BRAC RIGHT_BRAC   
%nonassoc ELSE
%left '<' '>'
%left '+' '-'
%left '*' '/'

%%

prog:HEADERS functions MAIN LEFT_PARENTHESIS RIGHT_PARENTHESIS LEFT_BRAC stat RIGHT_BRAC 

HEADERS: HEADERS HEADER
	| HEADER {  printf("Successfully Declared Header File\n");  }

stat:
        stat statement 
        | statement;

statement:
	if_conditions | assig | for_loop | function_call | while_loop |declaration |switch_case
	;

functions:functions function|
			function;
function:
	head body { 
            printf("Inside Function\n"); 
            }
	| ;

head:
    type VAR LEFT_PARENTHESIS param RIGHT_PARENTHESIS {
    printf("Function Define Including  Parameter \n");
    }
    |type VAR LEFT_PARENTHESIS  RIGHT_PARENTHESIS {
    printf("Function define Without  Parameter \n");
    }

;


param:
		| parameter ',' param
		| parameter  

;

parameter :
            type VAR
            ;

function_call:
        VAR LEFT_PARENTHESIS call_param RIGHT_PARENTHESIS ';' {printf("Call The Valid Function\n");}
     
call_param :
        call_param VAR
		{
		
			if(check($2)){
					
					printf("\n===>>%s parameter ",$2);
					
				
			}else{
					printf("ERROR: ###%s Variable Not DEclared Yet   ",$2); 
					
					}
		}
	 | VAR{
		
			if(check($1)){
					
					printf("\n===>>%s parameter used in ",$1);
					
				
			}else{
					printf("ERROR: ###%s Variable Not DEclared Yet",$1); 
					}
		}
 ;


for_loop:
            FOR VAR  exp '-' exp ':' body 
            { 
            printf(" For Loop Start and End from %d - %d \n",$3,$5);
            }

while_loop:
            WHILE LEFT_PARENTHESIS exp RIGHT_PARENTHESIS body
             {
             printf("Successfully While Loop Declared\n");
             }


switch_case: SWITCH ':' LEFT_BRAC cases RIGHT_BRAC;

cases: cases case
		| case
		;

case: CASE exp LEFT_BRAC assign RIGHT_BRAC{
							if($2)
							{
								printf("  Value From SWITCH CASE\n" ); 
								sw++;
							}
						}

	| DEFAULT LEFT_BRAC assign RIGHT_BRAC{ if(sw == 0)
							{
								printf("Value From DEFAULT CASE\n");
								sw=0;
							}
						}
	;


if_conditions:
            IF  exp  body else_if optional_else {
            		if($2 ) {
						printf("Value From IF Block :\n");
						q++;
						}

						
						
				}
           
            |IF  exp  body optional_else
            {
            		if($2) {
						printf("Value From IF Block ");
						q++;
						}
				}
            ;

else_if:
        else_if ELIF exp body {
        
        	if($3) {
						printf("Value From ESLE IF Block \n");
						}
        }
        |
        ;


optional_else:
        ELSE body {
        printf("else %d",q);
        	if(q == 0) {
						printf("Value From ESLE IF block \n");
						}
        }
        |   
        ;



body:
    statement ';' 
    |LEFT_BRAC stat RIGHT_BRAC ;




exp:
    NUM    {$$=$1;}
    |VAR { 
		 int i = 1;
		 char *name = a1[i].str;
		    while (name) {
			        if (strcmp(name, $1) == 0){
						$$=a1[i].n;
						break;
				            }
					name = a1[++i].str;
				}

}
    |exp PLUS exp {
    		$$=$1+$3;
    		}
    |exp MIN exp {$$=$1-$3;}
    |exp MUL exp {$$=$1*$3;}
    |exp DIV exp {if($3)
    {
        $$=$1/$3;
        } else
            {
            $$=0;
            printf("\ninvalid");
            }}
    |exp LT exp {$$=$1 < $3;}
    |exp GT exp {$$=$1 > $3;}
    |'(' exp ')' {$$=$2;}
    |exp UP { 
    						$$=$1 + 1; 
    		}
    |exp UM { $$=$1- 1; }
    |exp GE exp {$$=$1 >= $3;}
    |exp LE exp {$$=$1 >= $3;}
    |exp AND exp {$$=$1 && $3;}
    |exp OR exp {$$=$1 || $3;}
    |NOT exp {$$=!$2;}
    |exp EQ exp {$$=$1==$3;}
    |exp NQ exp {$$=$1!=$3;}
    ;




 assign :assign assig 
 		| assig
assig:
    VAR '=' exp ';'{
			if(check($1)){
					
					value_assign ($1,$3);
					printf("\nValue of the Variable ###%s= %d\t",$1,$3);
					
				
			}else{
					printf("\n(%s) Variable Not DEclared Yet",$1); 
					}
		
		}
            ;

type:
    INT |
    CHAR|
    FLOAT|
    DOUBLE
    ;

declaration: type VAR1 ';'{	
} ;
VAR1  : VAR1 ',' VAR	{ 

						if(check($3))
						{
							printf("\nALERT:Multiple Declaration Of Variable ###%s \n", $3 );
						
						}
						else
						{
							printf("###%s Variable Declared Successfully\n",$3);
							variable(&a1[count],$3, count);
							q=1;
							count++;
							
						}
					}

     |VAR		{

						if(check($1))
						{
							printf("\nALART:Multiple Declaration Of Variable ###%s \n", $1 );
						}
						else
						{
							printf("###%s Variable DeclaredSuccessfully\n",$1);
							variable(&a1[count],$1, count);
							count++;

							
						}
			}
     ;
%%

    void variable(array *p, char *s, int n)
				{
				  p->str = s;
				  p->n = n;
				}
   void value_assign(char *s, int num)
				{
				    int i = 1;
				    char *name = a1[i].str;
				    while (name) {
				        if (strcmp(name, s) == 0){
					a1[i].n=num;
						break;
				            }
					name = a1[++i].str;
				}
			}

				int check(char *key)
				{
				
				    int i = 1;
				    char *name = a1[i].str;
				    while (name) {
				        if (strcmp(name, key) == 0){

				            return i;}

				        name = a1[++i].str;
					

				    }
				    return 0;
				}

				


void yyerror(char *s)
{
    printf("%s\n",s);
}
int yywrap()
{
    return 1;
}
