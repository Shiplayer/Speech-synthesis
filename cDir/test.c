#include <stdlib.h>
#include <stdio.h>

int* test(int num, int** array){
	for(int i = 0; i < 10; i++){
		printf("%d ", array[i][1]);
	}
	printf("\n%d\n", num);
	int* arr = malloc(sizeof(int) * 10);
	for(int i = 0; i < 10; i++){
		arr[i] = 0;
		if(i < num)
			arr[i] = array[i][0] + array[i][1];
		else
			arr[i] = i;
		printf("%d ", arr[i]);
	}
	printf("\n");
	return arr;
}

int main(int argc, char** argv){
	printf("%d\n", argc);
	for(int i = 0; i < argc; i++)
		printf("%s\n", argv[i]);
	return 0;
}
