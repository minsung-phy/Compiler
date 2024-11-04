%option noinput nounput

%{
#include <stdio.h>
#include <stdlib.h>
#include "calc.tab.h"
%}

FRAC [0-9]+([.][0-9]*)?|[.][0-9]+
EXP  [Ee][+-]?[0-9]+

%%

"+" { return '+'; }
"-" { return '-'; }
"*" { return '*'; }
"/" { return '/'; }
"(" { return '('; }
")" { return ')'; }
\n { return EOL; }
{FRAC}{EXP}? { yylval.d = atof(yytext); return NUMBER; }
(?i:quit)|(?i:exit) { return YY_NULL; }
--.*  { /* skip comments */ }
[ \t]   { /* skip whitespace */ }
.       { printf("unknown character %c\n", yytext[0]); }

%%
