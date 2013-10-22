#include <stdio.h>

int test(){
	return ({
		int a = 3;
		int b = 2;
		a+b;
	});
}

int main(){
	printf("%d\n", test());
}
