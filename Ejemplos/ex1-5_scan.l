%option noyywrap
%{
#include "ex1-5_calc.tab.h"
#include <stdlib.h>
%}
%%
"//".*      ;               /* ignora comentarios estilo // ... */
[ \t\r]+    ;
\n          { return EOL; }

"("         { return OP; }
")"         { return CP; }
"|"         { return ABS; }

[0-9]+      { yylval.num = strtol(yytext, NULL, 10); return NUMBER; }

"+"         { return '+'; }
"-"         { return '-'; }
"*"         { return '*'; }
"/"         { return '/'; }

.           { /* carácter desconocido: ignora */ }
%%
