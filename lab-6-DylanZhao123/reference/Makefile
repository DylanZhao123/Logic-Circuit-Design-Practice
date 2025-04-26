CC=gcc
CFLAGS=-g -Wall -Werror

all: bingen bst sqr

bingen: bingen.c
	$(CC) bingen.c -o bingen $(CFLAGS)

bst: bst.h bst.c
	$(CC) bst.c -o bst $(CFLAGS)

sqr: lecture/sqr.c
	$(CC) lecture/sqr.c -o lecture/sqr $(CFLAGS)

clean:
	rm bingen bst lecture/sqr
