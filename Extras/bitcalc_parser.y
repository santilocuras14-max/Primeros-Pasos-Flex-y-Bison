%{
#include <stdio.h>
#include <math.h>
int yylex(void);
void yyerror(const char *s){ fprintf(stderr, "error: %s\n", s); }
%}
%union { long num; }
%token <num> NUMBER
%token EOL OP CP ABS
%left '|'          /* OR bit a bit (baja precedencia) */
%left '&'          /* AND bit a bit  */
%left '+' '-'
%left '*' '/'
%right UMINUS UABS

%type <num> exp

%%
input: /* vacío */ | input line ;
line:  exp EOL   { printf("%ld (0x%lX)\n", $1, (unsigned long)$1); }
    |  EOL
    ;

exp:   exp '|' exp        { $$ = $1 | $3; }
    |  exp '&' exp        { $$ = $1 & $3; }
    |  exp '+' exp        { $$ = $1 + $3; }
    |  exp '-' exp        { $$ = $1 - $3; }
    |  exp '*' exp        { $$ = $1 * $3; }
    |  exp '/' exp        { $$ = $1 / $3; }
    |  '-' exp %prec UMINUS { $$ = -$2; }
    |  ABS exp ABS %prec UABS { long t = $2; $$ = (t>=0)?t:-t; }
    |  OP exp CP          { $$ = $2; }
    |  NUMBER
    ;
%%
int main(void){ return yyparse(); }
