%{
#include "y.tab.h"
%}

%%
"traffic"      return TRAFFIC;
"begin"        return BEGINN;
"end"          return END;
"signal"       return SIGNAL;
"red"          return RED;
"green"        return GREEN;
"if"           return IF;
"then"         return THEN;
"else"         return ELSE;
"print"        return PRINT;

"=="            return EQ;
"="             return ASSIGN;
";"             return SEMI;

[a-zA-Z]+       return ID;

[ \t\n]         ;
.               ;
%%

int yywrap() { return 1; }
