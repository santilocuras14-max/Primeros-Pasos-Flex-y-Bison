%{
#include <stdio.h>
#include <stdlib.h>
%}
%option noyywrap

%%
[0-9]+      { printf("NUMBER(%ld)\n", strtol(yytext, NULL, 10)); }
"|"         { printf("ABS\n"); }        /* abs unario (se decide en parser en ex1-5) */
"+"         { puts("PLUS"); }
"-"         { puts("MINUS"); }
"*"         { puts("MUL"); }
"/"         { puts("DIV"); }
"("         { puts("OP"); }
")"         { puts("CP"); }
"//".*      ;                           /* comentario hasta fin de línea */
\n          { puts("EOL"); }
[ \t\r]+    ;
.           { printf("MYSTERY(%c)\n", yytext[0]); }
%%
int main(void){ return yylex(); }
