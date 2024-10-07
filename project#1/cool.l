%option noinput nounput
%{
#include <stdio.h>
#include <stdlib.h>
#include "cool.tab.h"
int lineNo = 1;
int comment_depth = 0;  /* 중첩 주석을 추적하기 위한 변수 */

void setErrMsg(const char* msg) {
    fprintf(stderr, "Error: %s at line %d\n", msg, lineNo);
}
%}

%x COMMENT
%x S_LINE_COMMENT

NEWLINE     (\r\n|\n)
WHITESPACE  [ \t]+

%%

"(*"                { comment_depth++; BEGIN(COMMENT); }

<COMMENT>"(*"       { comment_depth++; }
<COMMENT>.          { /* 주석 내부의 문자 무시 */ }
<COMMENT>\n         { lineNo++; }
<COMMENT>"*)"       { comment_depth--; if (comment_depth == 0) BEGIN(INITIAL); }

<COMMENT><<EOF>>    { setErrMsg("EOF in comment"); exit(1); }

"*)"                { setErrMsg("Unmatched *)"); exit(1); }

"--"                { BEGIN(S_LINE_COMMENT); }

<S_LINE_COMMENT>[^\n]*  { /* 한 줄 주석 무시 */ }

<S_LINE_COMMENT>\n  { lineNo++; BEGIN(INITIAL); }

{WHITESPACE}    /* SKIP */
{NEWLINE}       { lineNo++; }

"Class"       { return CLASS; }
"class"       { return CLASS; }
"inheritS"    { return INHERITS; }
"inherits"    { return INHERITS; }
"If"          { return IF; }
"if"          { return IF; }
"then"        { return THEN; }
"ELSE"        { return ELSE; }
"else"        { return ELSE; }
"fi"          { return FI; }
"while"       { return WHILE; }
"loop"        { return LOOP; }
"pool"        { return POOL; }
"let"         { return LET; }
"in"          { return IN; }
"case"        { return CASE; }
"of"          { return OF; }
"esac"        { return ESAC; }
"new"         { return NEW; }
"isvoid"      { return ISVOID; }
"true"        { return TRUE; }
"false"       { return FALSE; }
"not"         { return NOT; }

[A-Z][a-zA-Z0-9_]* { return TYPE; }

[a-zA-Z_][a-zA-Z0-9_]*    {
    return ID;
}

[0-9]+    {
    return INTEGER;
}

\"([^\"\n\\]|\\[btnf\"\\])*\" {
    /* 큰따옴표를 제외하고 문자열을 처리 */
    char *str = strdup(yytext + 1);  /* 처음 큰따옴표 제거하고 복사 */
    str[strlen(str) - 1] = '\0';  /* 마지막 큰따옴표 제거 */
    free(str);  /* 할당된 메모리 해제 */
    return STRING;
}

"("     { return LPAREN; }
")"     { return RPAREN; }
"{"     { return LBRACE; }
"}"     { return RBRACE; }
"<="    { return LTE; }
"<-"    { return ASSIGN; }
"<"     { return LT; }
"=>"    { return DARROW; }
"="     { return EQUAL; }
","     { return COMMA; }
";"     { return SEMICOLON; }
":"     { return COLON; }
"."     { return DOT; }
"+"     { return PLUS; }
"-"     { return MINUS; }
"*"     { return MUL; }
"/"     { return DIV; }
"~"     { return NEG; }
"@"     { return ATSIGN; }

.       { fprintf(stderr, "Invalid character %s in line %d\n", yytext, lineNo);
          exit(1);
        }

%%

int main(int argc, char *argv[])
{
    int token;

    /*
     * 스캔할 COOL 파일을 연다. 파일명이 없으면 표준입력이 사용된다.
     */
    if (argc > 1)
        if (!(yyin = fopen(argv[1],"r"))) {
            printf("\"%s\"는 잘못된 파일 경로입니다.\n", argv[1]);
            exit(1);
        }
    /* 
     * 토큰을 식별할 때마다 줄번호, 타입, 문자열(lexeme)을 출력한다
     */
    for (token = yylex(); token != YY_NULL; token = yylex())
        printf("%03d:[%s] %s\n", lineNo, tokenName[token-100], yytext);
}