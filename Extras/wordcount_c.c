#include <stdio.h>
#include <ctype.h>

int main(int argc, char **argv){
    if(argc < 2){ fprintf(stderr, "Uso: %s archivo...\n", argv[0]); return 1; }
    for(int i=1;i<argc;i++){
        FILE *f = fopen(argv[i],"rb");
        if(!f){ perror(argv[i]); continue; }
        unsigned long lines=0, words=0, chars=0;
        int c, inword=0;
        while((c = fgetc(f)) != EOF){
            chars++;
            if(c=='\n') lines++;
            if(isspace(c)) inword=0;
            else if(!inword){ inword=1; words++; }
        }
        fclose(f);
        printf("%s: %lu %lu %lu\n", argv[i], lines, words, chars);
    }
    return 0;
}
