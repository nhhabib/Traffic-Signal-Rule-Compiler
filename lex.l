%{
#include "y.tab.h"
#include <stdlib.h>
%}

%%
"red"           return RED;
"green"         return GREEN;
"yellow"        return YELLOW;

"speed"         return SPEED;
">"             return GT;

"time"          return TIME;
"day"           return DAY;
"night"         return NIGHT;

"vehicle"       return VEHICLE;
"ambulance"     return AMBULANCE;
"normal"        return NORMAL;

[0-9]+          { yylval = atoi(yytext); return NUM; }

[ \t\n]         ;
.               return INVALID;
%%

int yywrap() { return 1; }
