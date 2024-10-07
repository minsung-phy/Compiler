%{
#include <stdio.h> 
%}

FRAC [0-9]+([.][0-9]*)?|[.][0-9]+
EXP [Ee][+-]?[0-9]+
NUM {FRAC}{EXP}?

%%

{NUM} { printf("%s는 올바른 수이다.\n", yytext); }
"exit" { return YY_NULL; }
. { printf("%s는 실수가 아니다.\n", yytext); }

%%

int main (void) 
{
    yylex();
    return 0;
}