all: anigauss.c
	gcc -c -Wall -fPIC anigauss.c
	gcc -shared -o libanigauss.so anigauss.o

clean:
	rm *.o *.so
