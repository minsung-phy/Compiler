/*
 * Copyright(c) 2020-2024 All rights reserved by Heekuck Oh.
 * 이 프로그램은 한양대학교 ERICA 컴퓨터학부 학생을 위한 교육용으로 제작되었다.
 * 한양대학교 ERICA 학생이 아닌 자는 이 프로그램을 수정하거나 배포할 수 없다.
 * 프로그램을 수정할 경우 날짜, 학과, 학번, 이름, 수정 내용을 기록한다.
 */
%option noinput nounput yylineno
%{
#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <string.h>
#include "node.h"
#include "cool.tab.h"
%}

NEWLINE     (\r\n|\n)
WHITESPACE  [ \t]+
DASHCOMMENT --.*\n

%%
                
{WHITESPACE}    /* skip */
{NEWLINE}       /* skip */
{DASHCOMMENT}   /* skip */

(?i:class)           { return CLASS; }
(?i:inherits)        { return INHERITS; }

"("     { return '('; }
")"     { return ')'; }
"{"     { return '{'; }
"}"     { return '}'; }
"<="    { return LTE; }
"<-"    { return ASSIGN; }
"<"     { return '<'; }
"=>"    { return DARROW; }
"="     { return '='; }
","     { return ','; }
";"     { return ';'; }
":"     { return ':'; }
"."     { return '.'; }
"+"     { return '+'; }
"-"     { return '-'; }
"*"     { return '*'; }
"/"     { return '/'; }
"~"     { return '~'; }
"@"     { return '@'; }
.       { fprintf(stderr, "Skip unknown character %s in line %d\n", yytext, yylineno); }

%%

