#
# Copyright 2020-2024. Heekuck Oh, all rights reserved
# 이 파일은 한양대학교 ERICA 컴퓨터학부 재학생을 위해 만들었다.
#
CC = gcc
CFLAGS = -Wall -O3
CLIBS = -ll
#
OS := $(shell uname -s)
ifeq ($(OS), Linux)
#	CLIBS +=
endif
ifeq ($(OS), Darwin)
	CLIBS += -mmacosx-version-min=15.0
endif
#
all: calc.tab.o lex.yy.o
	$(CC) -o calc calc.tab.o lex.yy.o $(CLIBS)

calc.tab.o: calc.tab.c
	$(CC) $(CFLAGS) -c calc.tab.c
	
lex.yy.o: lex.yy.c
	$(CC) $(CFLAGS) -c lex.yy.c

calc.tab.h calc.tab.c: calc.y
	bison -d calc.y
	
lex.yy.c: calc.l calc.tab.h
	flex calc.l

clean:
	rm -rf *.o
	rm -rf calc
	rm -rf calc.tab.c calc.tab.h lex.yy.c
