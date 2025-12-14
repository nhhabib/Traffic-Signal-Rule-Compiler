%{
#include "y.tab.h"
#include <stdlib.h>
#include <string.h>
%}

/* case insensitive */
%option noyywrap
%option caseless

%%
"red"           return RED;
"green"         return GREEN;
"yellow"        return YELLOW;

"speed"         return SPEED;
">"             return GT;

[0-9]+          { yylval = atoi(yytext); return NUM; }

[a-zA-Z]+       return ID;

[ \t\n]         ;
.               return INVALID;
%%
