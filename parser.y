%{
#include <stdio.h>

int yylex(void);
int yyerror(const char *s);
%}

%token TRAFFIC BEGINN END IF THEN ELSE PRINT
%token SIGNAL RED GREEN ID
%token ASSIGN EQ SEMI NUM

%%
program:
    TRAFFIC BEGINN statements END
;

statements:
    SIGNAL ASSIGN RED SEMI decision
;

decision:
    IF SIGNAL EQ RED THEN PRINT ID SEMI
    ELSE PRINT ID SEMI
;
%%

int main() {
    yyparse();
    printf("Parsing Successful\n");
    return 0;
}

int yyerror(const char *s) {
    printf("Syntax Error\n");
    return 0;
}
