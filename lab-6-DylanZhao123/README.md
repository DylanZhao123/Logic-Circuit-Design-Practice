<!-- omit in toc -->
# Lab 6

In this lab, you will implement three recursive MIPS procedures, which requires usage of the stack.

First, you will implement `bingen`, which prints the bit patterns of length `N` (e.g., if `N = 3`, the patterns are `000`, `001`, ... , `111`). Then, you will implement a binary search tree's (BST) `insert` and `inorder` functions.

<details open>
  <summary>Overview</summary>

- [Background information](#background-information)
    - [Reference code](#reference-code)
    - [macros](#macros)
    - [Getting started](#getting-started)
    - [Advice](#advice)
- [`bingen`](#bingen)
    - [I/O example](#io-example)
    - [Working with strings](#working-with-strings)
- [BST](#bst)
    - [BST review](#bst-review)
    - [Understand given code](#understand-given-code)
    - [`insert`](#insert)
        - [I/O example](#io-example-1)
        - [Submit code](#submit-code)
    - [`inorder`](#inorder)
        - [I/O example](#io-example-2)
- [Submit your assignment](#submit-your-assignment)
</details>

## Background information

### Reference code

Reference C code is provided in [reference/](reference/). `cd reference` and compile the programs with `make all` or `gcc`, if installed, and run to see what they do.

The autograder `diff`s the outputs of your MIPS program and the corresponding reference program when both are provided the same inputs, and any differences (except for leading or trailing whitespace) will result in no credit.

### macros

There are several additions to [macros.asm](macros.asm):

1. There is one new macro for `bingen`: `print_str_label`. There are two new macros for the BST implementation: `sbrk` and `new_node`. These macros will make implementation easier for you. Please read the comments near the macros to see how to use them.
2. All macros now use the stack to save and restore `$a0`. Thus, our macros will not clobber `$a0`, which may be used by your code. For example, if `$a0` holds the value 1 when you invoke a macro, `$a0` will continue to hold the value 1 after the macro body is done executing.
    * As mentioned in the comments, this does not follow the MIPS caller-callee contracts because our macros usually behave like callees so should not save the `a` registers. However, this will make your life a lot easier.

### Getting started

If you don't know where to start with recursive MIPS code, review lecture content regarding procedures and stacks, including Template 1, which is particularly important because its 8 lines of code are reused in the other 5 templates, and the Gradescope questions. Finally, an example recursive program is provided in [reference/example/sqr.asm](reference/example/sqr.asm) and is heavily commented. We strongly recommend understanding this code before proceeding with this lab.

### Advice

When writing recursive MIPS assembly code for this lab, you will not need to keep track of a lot of registers. For example, our solution code for `bst.asm` uses only one temporary register `$t0` to implement `insert`, in addition to the necessary ones: `$a0`, `$a1`, `$sp`, `$fp`, `$ra`, and `$v0`. Even though this may seem like a lot, the necessary ones shouldn't be hard to keep track of because they're part of our stack/procedure templates.

The difficulty is that you now have to handle saving and restoring registers, per the MIPS caller-callee contracts. Before and while writing code, keep the following in mind about the registers you use:

* If a register is clobbered by a function call but you need to access its old value (before the function call), the register needs to be saved and restored.
* If a register is never clobbered or is clobbered but you don't need to access its old value, it does not need to be saved and restored.
* How many temporary registers do you need, if any? Can you use one register for multiple purposes? Using fewer registers may make coding easier.

Before implementing a function, please write your planned stack frame (similar to the ones from lecture and in [reference/example/sqr.asm](reference/example/sqr.asm)) in a comment above the function. As you code, if it is necessary to update the comment, do so. Something as simple as the following will help a lot.

```mips
# $fp -> $ra
#        $fp
# $sp -> $a1
```

Note: This is our stack frame for our [bingen.asm](bingen.asm) solution code.

Lastly, you shouldn't have to write a lot of code. The number of additional lines that our solution code has that isn't in the template code (including comments and several copy-pasted lines of boilerplate code from Template 1) is

```text
$ diff -y --suppress-common-lines template/bingen.asm bingen.asm | wc -l
36
$ diff -y --suppress-common-lines template/bst.asm bst.asm | wc -l
66
```

## `bingen`

Use [bingen.c](reference/bingen.c) as a reference to implement `bingen` in [bingen.asm](bingen.asm).

### I/O example

```text
Enter the number of bits (1 <= N <= 16): 3
000
001
010
011
100
101
110
111
```

### Working with strings

In [bingen.asm](bingen.asm), the string `pattern` is stored in the `.data` section. To see how to store to it (i.e., `pattern[x] = y`) and print it, see the comment next to its declaration.

## BST

After reading the following, use [bst.c](reference/bst.c) as a reference to implement `insert` and `inorder` in [bst.asm](bst.asm).

### BST review

Recall from COMP 210 that a BST is a binary tree where all values in the left subtree are less than the value at the root, and all values in the right subtree are greater than or equal to the value at the root.

In [bst.h](reference/bst.h), we represent this structure as

```c
typedef struct BST {
  int data;
  struct BST* left;
  struct BST* right;
} BST;
```

### Understand given code

Read through [reference/bst.c](reference/bst.c).

Before implementing `insert` and `inorder`, you must understand the macro `new_node` in [macros.asm](macros.asm). For a visual aid, see the heap memory diagram for the example BST insertions below.

In `new_node`, there are 4 simple self-check questions in comments that you should be able to answer. If you cannot answer them, it may be difficult to implement the BST functions. To check your work, our answers are in this footnote: [^new_node_answers]

[^new_node_answers]: 1. 4 bytes for `int data` and 4 bytes each for `struct BST*` (32-bit pointer). 2. We choose to store `int data` at the first 4 bytes of the allocated memory (i.e., starting at byte 0). 3. We choose to store `struct BST* left` at the next 4 bytes of the allocated memory (i.e., starting at byte 4). 4. We choose to store `struct BST* right` at the last 4 bytes of the allocated memory (i.e., starting at byte 8).

In short, although we are using a new system call `sbrk` that returns a pointer, a pointer is just a memory address. We have worked with memory addresses and pointer arithmetic using load and store instructions in the previous MIPS lab and lectures, so this should be familiar.

Lastly, for both functions, when comparing to `NULL`, you can simply write `NULL`. This is because of the line `.eqv NULL 0` in `macros.asm`.

### `insert`

In [bst.asm](bst.asm), implement `insert`.

#### I/O example

```text
Enter BST size: 5
Value 0: 2
Value 1: 5
Value 2: 1
Value 3: 3
Value 4: 4
Inorder: 
```

<p align="center">
    <img src="https://i.imgur.com/Is0iRBK.png">
</p>
<p align="center"><em>BST formed by insertions 2, 5, 1, 3, 4</em></p>

In the Execute menu's Data Segment, change the address to `0x00002000 (heap)`, and toggle off Hexadecimal Addresses and Hexadecimal Values.

<p align="center">
    <img src="https://i.imgur.com/3SCY6AJ.png">
</p>
<p align="center"><em>Settings</em></p>

You should see the following:

<p align="center">
    <img src="https://i.imgur.com/twfbL8x.png">
</p>
<p align="center"><em>Heap after inserting 2, 5, 1, 3, 4</em></p>

<p align="center">
    <img src="https://i.imgur.com/4EEmkSM.png">
</p>
<p align="center"><em>2 points to 1 (left) and 5 (right); 5 points to <code>NULL</code> (right)</em></p>

#### Submit code

Once you think `insert` works, submit to Gradescope. The autograder will run your code on certain inputs and dump heap memory. It will do the same for our reference assembly code and run a `diff`. Any differences will result in no credit.

Do not start `inorder` without getting full points for `insert`. The `inorder` tests will also check heap memory so will fail if `insert` is not implemented correctly. Note that this means you may not implement `inorder` by pasting your bubble sort code from a previous lab because the heap memory would not match.

### `inorder`

Implement `inorder`.

#### I/O example

```text
Enter BST size: 5
Value 0: 2
Value 1: 5
Value 2: 1
Value 3: 3
Value 4: 4
Inorder: 1 2 3 4 5 
```

## Submit your assignment

See the [instructions for assignment submission](https://github.com/COMP311/submit-assignment).
