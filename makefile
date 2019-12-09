CC = g++
CFLAGS=-c -Wall
OBJS = format.h

all: parse
parse: Source.o
	$(CC) Source.o -o parse
Source.o: Source.cpp 
	$(CC) $(CFLAGS) Source.cpp 
clean:
	rm -rf *o parse

