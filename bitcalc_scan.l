%option noyywrap
%{
#include "bitcalc.tab.h"
#include <stdlib.h>
%}
HEX    0[xX][0-9a-fA-F]+
%%
"//".*      ;
[ \t\r]+    ;
\n          { return EOL; }
"("         { return OP; }
")"         { return CP; }
"|"         { return '|'; }    /* OR bit a bit en esta variante */
"&"         { return '&'; }
{HEX}       { yylval.num = strtol(yytext, NULL, 16); return NUMBER; }
[0-9]+      { yylval.num = strtol(yytext, NULL, 10); return NUMBER; }
"+"         { return '+'; }
"-"         { return '-'; }
"*"         { return '*'; }
"/"         { return '/'; }
.           ;
%%
