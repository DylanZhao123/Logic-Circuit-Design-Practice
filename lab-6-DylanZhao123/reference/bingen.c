#include <stdio.h>

char pattern[17] = {0};

void bingen(unsigned int N, unsigned int n);

// Given in bingen.asm
int main() {
  unsigned int N = 0;
  printf("Enter the number of bits (1 <= N <= 16): ");
  scanf("%u", &N);

  unsigned int n = N;
  pattern[N] = '\0';  // Null-terminate
  bingen(N, n);
  return 0;
}

void bingen(unsigned int N, unsigned int n) {
  if (n > 0) {
    pattern[N - n] = '0';
    bingen(N, n - 1);
    pattern[N - n] = '1';
    bingen(N, n - 1);
  } else
    printf("%s\n", pattern);
}
