%{
#include "y.tab.h"
#include <stdlib.h>
%}

%option caseless
%option noyywrap

%%
"red"           return RED;
"green"         return GREEN;
"yellow"        return YELLOW;

"lane1"         return LANE1;
"lane2"         return LANE2;

"speed"         return SPEED;
">"             return GT;

"vehicle"       return VEHICLE;
"ambulance"     return AMBULANCE;
"normal"        return NORMAL;

[0-9]+          { yylval = atoi(yytext); return NUM; }

[ \t\n]         ;
.               return INVALID;
%%
