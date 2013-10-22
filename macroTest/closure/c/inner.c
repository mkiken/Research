#define LAMBDA(rettype, ARG_LIST, BODY)          \
({                                               \
   rettype __lambda_funcion__ ARG_LIST { BODY; } \
   __lambda_funcion__;                           \
})
#include <stdio.h>

int (*sum)(int, int, int);

void function(void) {
	int d = 19;
	sum = LAMBDA(int, (int a, int b, int c), {
  return a + b + d;
});
  printf("%d\n", sum(1,2,3));
}

int main(){
	function();
	printf("%d\n", sum(5,6,7));
}
