/*
 * E -> E+E | E-E | E*E | E/E | (E) | +E | -E | number
 */
%{
#include <stdio.h>
int yylex();
void yyerror(const char *s);
%}

%union {
    double d;
}

%token <d> NUMBER
%token EOL

%left '+' '-'
%left '*' '/'

%type <d> expr
%start expr_list
%%

expr_list: expr_list expr EOL {
        printf("%.10g\n", $2);
        printf("> ");
}
    | expr_list EOL { printf("> "); }
    | /* epsilon */ { }
    | error EOL { printf("> "); }
    ;

expr: expr '+' expr { $$ = $1 + $3; }
    | expr '-' expr { $$ = $1 - $3; }
    | expr '*' expr { $$ = $1 * $3; }
    | expr '/' expr { $$ = $1 / $3; }
    | '(' expr ')' { $$ = $2; }
    | '+' expr { $$ = $2; }
    | '-' expr { $$ = -$2; }
    | NUMBER { $$ = $1; }
    ;

%%

void yyerror(const char *s)
{
    printf("%s\n", s);
}

int main(void)
{
    printf("> ");
    yyparse();
    return 0;
}
