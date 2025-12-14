%{
#include <stdio.h>

int yylex(void);
int yyerror(const char *s);
%}

%token TRAFFIC BEGINN END IF THEN ELSE PRINT
%token SIGNAL RED GREEN ID
%token ASSIGN EQ SEMI

%%
program:
    TRAFFIC BEGINN statements END {
        printf("Program finished.\n");
    }
;

statements:
    SIGNAL ASSIGN RED SEMI decision
  | SIGNAL ASSIGN GREEN SEMI decision
;

decision:
    IF SIGNAL EQ RED THEN PRINT ID SEMI {
        printf("OUTPUT: STOP\n");
    }
    ELSE PRINT ID SEMI {
        printf("OUTPUT: GO\n");
    }
;
%%

int main() {
    printf("Enter traffic rule input:\n");
    yyparse();
    return 0;
}

int yyerror(const char *s) {
    printf("Syntax Error\n");
    return 0;
}
