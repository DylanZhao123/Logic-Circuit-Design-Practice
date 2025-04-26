#include "bst.h"

#include <stdio.h>
#include <stdlib.h>

// Given in bst.asm
int main() {
  int size = 0;
  int val;
  printf("Enter BST size: ");
  scanf("%d", &size);
  printf("Value 0: ");
  scanf("%d", &val);
  BST* bst = new_node(val);
  for (int i = 1; i < size; i++) {
    printf("Value %d: ", i);
    scanf("%d", &val);
    insert(bst, val);
  }
  printf("Inorder: ");
  inorder(bst);
  printf("\n");
  return 0;
}

// Given in macros.asm
BST* new_node(int x) {
  /**
   * To review malloc (covered in 211):
   * https://www.tutorialspoint.com/c_standard_library/c_function_malloc.htm
   *
   * There is no malloc in MIPS
   * However, malloc uses sbrk internally, which MARS provides via system call 9
   * https://en.wikipedia.org/wiki/Sbrk or run `man sbrk`
   * For this lab, you can treat malloc and sbrk as the same thing
   */
  BST* node = malloc(sizeof(BST));

  /**
   * To review C's arrow operator (->) (covered in 211):
   * https://stackoverflow.com/a/2575050/18479243
   */
  node->data = x;
  node->left = NULL;
  node->right = NULL;
  return node;
}

BST* insert(BST* root, int x) {
  if (root == NULL) {
    return new_node(x);
  } else if (x < root->data) {
    root->left = insert(root->left, x);
  } else {
    root->right = insert(root->right, x);
  }
  return root;
}

void inorder(BST* root) {
  if (root != NULL) {
    inorder(root->left);
    printf("%d ", root->data);
    inorder(root->right);
  }
}
