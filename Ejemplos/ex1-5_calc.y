%{
#include <stdio.h>
#include <math.h>
int yylex(void);
void yyerror(const char *s){ fprintf(stderr, "error: %s\n", s); }
%}

%union {
    long num;
}

%token <num> NUMBER
%token EOL ABS OP CP
%type <num> exp term

%%
input: /* vacío */
    | input line
    ;

line:   exp EOL     { printf("%ld\n", $1); }
    |   EOL
    ;

exp:    exp '+' term    { $$ = $1 + $3; }
    |   exp '-' term    { $$ = $1 - $3; }
    |   term
    ;

term:   term '*' factor  { $$ = $1 * $3; }
    |   term '/' factor  { $$ = $1 / $3; }
    |   factor
    ;

factor: NUMBER
    |   ABS factor       { $$ = ($2 >= 0) ? $2 : -$2; }
    |   OP exp CP        { $$ = $2; }
    ;

%%
int main(void){ return yyparse(); }
