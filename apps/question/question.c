#include <stdio.h>
int main(int argc, char ** argv) {
  printf("How old are you?\n");
  int age;
  scanf("%d", &age);
  printf("You're %d years old.", age);
}