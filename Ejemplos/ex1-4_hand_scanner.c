#include <stdio.h>
#include <ctype.h>

int main(void){
    int c;
    while((c = getchar()) != EOF){
        if(isspace(c)){
            if(c=='\n') puts("EOL");
            continue;
        } else if(isdigit(c)){
            long v = c - '0';
            while((c = getchar()) != EOF && isdigit(c)){
                v = v*10 + (c - '0');
            }
            printf("NUMBER(%ld)\n", v);
            if(c==EOF) break;
            ungetc(c, stdin);
        } else {
            switch(c){
                case '+': puts("PLUS"); break;
                case '-': puts("MINUS"); break;
                case '*': puts("MUL"); break;
                case '/': puts("DIV"); break;
                case '(': puts("OP"); break;
                case ')': puts("CP"); break;
                case '|': puts("ABS_OR_BAR"); break;
                default:  printf("MYSTERY(%c)\n", c); break;
            }
        }
    }
    return 0;
}
