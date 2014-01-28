#include <stdio.h>

int callCount(void){
  static int count = 0;
  return (++count);
}

void doIt(){
  printf("%d\n", callCount());
  printf("%d\n", callCount());
  printf("%d\n", callCount());
  printf("%d\n", callCount());
  printf("%d\n", callCount());
  printf("%d\n", callCount());
  printf("%d\n", callCount());

}

int main(){
  doIt();
}
