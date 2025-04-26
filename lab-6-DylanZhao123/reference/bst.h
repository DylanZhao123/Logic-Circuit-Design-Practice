#ifndef BST_H
#define BST_H

typedef struct BST {
  int data;
  struct BST* left;
  struct BST* right;
} BST;

// Given in bst.asm
int main();

// Given in macros.asm
BST* new_node(int x);

// If root != NULL, insert new node with data x into root, and return root
// Else, return pointer to new node with data x
BST* insert(BST* root, int x);

// Print inorder traversal in one line with a space after each element
void inorder(BST* root);

#endif  // BST_H
