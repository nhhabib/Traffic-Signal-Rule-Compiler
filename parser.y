%{
#include <stdio.h>
#include <stdlib.h>

int yylex(void);
int yyerror(const char *s);

/* Symbol Table (simple) */
void symbol(const char *name) {
    printf("[Symbol Table] %s\n", name);
}
%}

/* Tokens */
%token RED GREEN YELLOW
%token SPEED NUM GT
%token TIME DAY NIGHT
%token VEHICLE AMBULANCE NORMAL
%token INVALID

%%
input:
      /* empty */
    | input rule
;

rule:
      signal_rule
    | speed_rule
    | time_rule
    | vehicle_rule
    | error_rule
;

/* 1️⃣ Signal rules */
signal_rule:
      RED     { symbol("signal"); printf("Signal Decision: STOP\n"); printf("ICG: IF signal==RED GOTO STOP\n"); }
    | GREEN   { symbol("signal"); printf("Signal Decision: GO\n");   printf("ICG: IF signal==GREEN GOTO GO\n"); }
    | YELLOW  { symbol("signal"); printf("Signal Decision: WAIT\n"); printf("ICG: IF signal==YELLOW GOTO WAIT\n"); }
;

/* 2️⃣ Speed rule */
speed_rule:
    SPEED GT NUM {
        symbol("speed");
        if ($3 > 60) {
            printf("Speed Decision: FINE\n");
            printf("ICG: IF speed>60 GOTO FINE\n");
        } else {
            printf("Speed Decision: SAFE SPEED\n");
            printf("ICG: IF speed<=60 GOTO SAFE\n");
        }
        printf("[Optimization] Constant folding applied\n");
    }
;

/* 3️⃣ Time-based rule */
time_rule:
    TIME DAY {
        symbol("time");
        printf("Time Decision: NORMAL SPEED\n");
        printf("ICG: IF time==DAY GOTO NORMAL\n");
    }
  | TIME NIGHT {
        symbol("time");
        printf("Time Decision: SLOW DOWN\n");
        printf("ICG: IF time==NIGHT GOTO SLOW\n");
    }
;

/* 4️⃣ Vehicle rule */
vehicle_rule:
    VEHICLE AMBULANCE {
        symbol("vehicle");
        printf("Vehicle Decision: PRIORITY ALLOWED\n");
        printf("ICG: IF vehicle==AMBULANCE GOTO ALLOW\n");
    }
  | VEHICLE NORMAL {
        symbol("vehicle");
        printf("Vehicle Decision: NORMAL RULES\n");
        printf("ICG: IF vehicle==NORMAL GOTO CHECK\n");
    }
;

/* 5️⃣ Error handling */
error_rule:
    INVALID {
        printf("Error: Invalid input detected\n");
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
