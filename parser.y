%{
#include <stdio.h>
#include <stdlib.h>

/* function prototypes */
int yylex(void);
int yyerror(const char *s);

/* ---------- GLOBAL STATE ---------- */
/* Priority flags */
int emergency = 0;

/* Lane states */
int lane1 = 0; // 0=STOP, 1=GO
int lane2 = 0;

/* Queue */
int queue = 5; // initial vehicles

/* AST printer */
void ast(const char *parent, const char *child) {
    printf("AST: (%s -> %s)\n", parent, child);
}
%}

/* ---------- TOKENS ---------- */
%token RED GREEN YELLOW
%token SPEED NUM GT
%token VEHICLE AMBULANCE NORMAL
%token LANE1 LANE2
%token INVALID

%%
input:
      /* empty */
    | input rule
;

rule:
      signal_rule
    | speed_rule
    | vehicle_rule
    | lane_rule
;

/* ---------- RULE PRIORITY (11) ---------- */
vehicle_rule:
    VEHICLE AMBULANCE {
        emergency = 1;
        ast("vehicle", "ambulance");
        printf("Priority Rule: Ambulance detected (OVERRIDE ALL)\n");
    }
  | VEHICLE NORMAL {
        emergency = 0;
        ast("vehicle", "normal");
        printf("Vehicle: Normal traffic\n");
    }
;

/* ---------- SIGNAL + AST (1) ---------- */
signal_rule:
    RED {
        ast("signal", "RED");
        if (!emergency) {
            lane1 = lane2 = 0;
            printf("Signal: RED → STOP\n");
        } else {
            printf("RED ignored due to ambulance priority\n");
        }
    }
  | GREEN {
        ast("signal", "GREEN");
        lane1 = lane2 = 1;
        printf("Signal: GREEN → GO\n");
    }
  | YELLOW {
        ast("signal", "YELLOW");
        lane1 = lane2 = 0;
        printf("Signal: YELLOW → WAIT\n");
    }
;

/* ---------- SPEED RULE ---------- */
speed_rule:
    SPEED GT NUM {
        ast("speed", "check");
        if ($3 > 60)
            printf("Speed > %d → FINE\n", $3);
        else
            printf("Speed OK\n");
    }
;

/* ---------- MULTI-LANE MODEL (14) ---------- */
lane_rule:
    LANE1 {
        ast("lane", "lane1");
        printf("Lane-1 status: %s\n", lane1 ? "GO" : "STOP");
    }
  | LANE2 {
        ast("lane", "lane2");
        printf("Lane-2 status: %s\n", lane2 ? "GO" : "STOP");
    }
;
%%

/* ---------- MAIN + SIMULATION (13) ---------- */
int main() {
    printf("Enter traffic rules (Ctrl+D to finish):\n");
    yyparse();

    printf("\n--- VEHICLE QUEUE SIMULATION ---\n");
    if (lane1 || lane2) {
        printf("Initial Queue: %d vehicles\n", queue);
        queue -= 3;
        if (queue < 0) queue = 0;
        printf("Vehicles passed: 3\n");
        printf("Remaining Queue: %d\n", queue);
    } else {
        printf("All lanes STOP → Queue remains: %d\n", queue);
    }

    printf("--- SIMULATION END ---\n");
    return 0;
}

int yyerror(const char *s) {
    printf("Syntax Error\n");
    return 0;
}
