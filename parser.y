%{
#include <stdio.h>
#include <stdlib.h>

int yylex(void);
int yyerror(const char *s);
int hasInput = 0;
%}

%token RED GREEN YELLOW
%token SPEED NUM GT
%token ID INVALID

%%
input:
      /* empty */ {
          if (!hasInput)
              printf("NO RULE PROVIDED\n");
      }
    | input rule
;

rule:
      signal_rule
    | speed_rule
    | type_error
;

/* Signal rules */
signal_rule:
      RED     { hasInput=1; printf("Signal Decision: STOP\n"); }
    | GREEN   { hasInput=1; printf("Signal Decision: GO\n"); }
    | YELLOW  { hasInput=1; printf("Signal Decision: WAIT\n"); }
;

/* Speed rule (correct) */
speed_rule:
    SPEED GT NUM {
        hasInput=1;
        if ($3 > 60)
            printf("Speed Decision: FINE\n");
        else
            printf("Speed Decision: SAFE SPEED\n");
    }
;

/* Type checking */
type_error:
    SPEED GT ID {
        hasInput=1;
        printf("Type Error: speed must be numeric\n");
    }
  | INVALID {
        hasInput=1;
        printf("Lexical Error: invalid token\n");
    }
;
%%

int main() {
    printf("Enter traffic rules (Ctrl+D to finish):\n");
    yyparse();
    return 0;
}

int yyerror(const char *s) {
    printf("Syntax Error\n");
    return 0;
}
