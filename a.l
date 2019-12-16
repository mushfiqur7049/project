%{
#include <stdio.h>
#include <string.h>
#include <math.h>
#include <stdlib.h>
#include "a.tab.h"

%}
letter [a-z]+
ID [a-zA-Z][a-zA-Z0-9]*
%%

"#include"["<"]{letter}["."]{letter}[">"] {return HEADER;}
[0-9]+ {yylval.number=atoi(yytext);
  		return NUM;}
"if"  {return IF;}
"else" {return ELSE;}
"else_if" {return ELIF;}
"to" {return TO;}
"for_loop" {return FOR;}
"while_loop" {return WHILE;}
"do" {return DO;}

"float_number" {return FLOAT;}
"int_number" {return INT;}
"double_number" {return DOUBLE;}
"char_value" {return CHAR;}
"void" {return VD;}
"LB"          {return LEFT_BRAC;}
"RB"          {return RIGHT_BRAC;}
"LP"          {return LEFT_PARENTHESIS;}
"RP"          {return RIGHT_PARENTHESIS;}
"increment"   {return UP;}
"decrement"    {return UM;}
"equal(=)"    {return EQ;}
"not_equal(!=)"    {return NQ;}
"ln"    {return LN;}
"sin"    {return SIN;}
"cos"    {return COS;}
"tan"    {return TAN;}
"additon(+)"    {return PLUS;}
"subtraction(-)"    {return MIN;}
"multiplication(*)"    {return MUL;}
"division(/)"    {return DIV;}
"greater_equal(>=)"    {return GE;}
"greater_than(>)"    {return GT;}
"less_than(<)"    {return LT;}
"less_equal(=<)"    {return LE;}
"and_operation(&&)"    {return AND;}
"or_operation(||)"    {return OR;}
"not_operation(!)"    {return NOT;}
"int main" {return MAIN;}
"switch"  {return SWITCH;}
"def"   {return DEFAULT;}
"case"   {return CASE;}
{ID} {
	 yylval.string = strdup(yytext);
         return VAR;} 


[-+/*<>=,();{}:~] {yylval.string=yytext[0];
		return *yytext;}

[ \t\n]*  ;

%%
int main()
{
    yyin=freopen("in.txt","r",stdin);
    yyout=freopen("out.txt","w",stdout);

    yyparse();

    fclose(yyin);
//fclose(yyout);
    return 0;
}