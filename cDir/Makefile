
main: test.so

test.so: test.o
	gcc -shared test.o -o test.so

test.o: test.c
	gcc -c test.c -o test.o -std=c11 -fpic


clean:
	rm *.o
	rm *.so
