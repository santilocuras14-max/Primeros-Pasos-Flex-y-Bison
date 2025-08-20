%option noyywrap
%%
[ \t\r\n]+   ;
[a-zA-Z_]+   ECHO;
[0-9]+       ECHO;
.            ECHO;
%%
