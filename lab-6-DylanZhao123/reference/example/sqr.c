/**
 * Procedure and stack programming example
 * See sqr.asm
 * Nothing to implement here
 */
#include <stdio.h>

int sqr(int x);

int main() {
  unsigned int n;
  printf("Non-negative integer to square: ");
  scanf("%d", &n);
  printf("%d\n", sqr(n));
  return 0;
}

int sqr(int x) {
  if (x > 1) {
    x = sqr(x - 1) + x + x - 1;
  }
  return x;
}
