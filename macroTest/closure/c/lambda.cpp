#include <iostream>
#include <vector>
using namespace std;

typedef int point;

int (*func)(int, int);
void (* po);
point pp;

#if 0
void doIt(){
  auto a = 3;
  cout << a << endl;
}
#endif

#if 0
void test02(){
  vector<int> v;
  find_if(v.begin(), v.end(), [](int x) -> bool { return x % 2 == 0; });
}
#endif

#if 1
void doIt(){
  int c = 100;
  func = [=](int a, int b) -> int { return a+c; };
  std::cout << func(7, 12) << std::endl;
}

#endif

#if 0
int test(){
  printf("test invoked.\n");
  return 1234;
}

void doIt(){
  int a = 1000;
  po = (void *)(&a);
  //pp = (point)(&a);
  printf("size = %d\n", (int)sizeof(&a));
  po = (void *)test;
}
#endif


int main(){
  doIt();
  cout << ((int(*)())po)() << endl;
  //std::cout << func(19, 12) << std::endl;
  //cout << *((int *)po) << endl;
  //cout << *((int *)pp) << endl;
}
