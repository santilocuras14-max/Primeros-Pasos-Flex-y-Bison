%{
#include <stdio.h>
static long lines=0, words=0, chars=0;
%}

%%
\n        { lines++; chars++; }
[ \t]+    { chars += yyleng; }      /* espacios: no cuentan como palabra */
[^\n \t]+ { words++; chars += yyleng; }
.         { chars++; }

%%
int main(void){
    yylex();
    printf("%ld %ld %ld\n", lines, words, chars);
    return 0;
}
