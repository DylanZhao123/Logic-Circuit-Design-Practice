<!-- omit in toc -->
# Lab 2

In this lab, you will implement a 32-bit ALU that performs all operations in our 5-bit ALUFN table. Specifically, it can add, subtract, AND, OR, XOR, NOR, shift left logical (`sll`), shift right logical (`srl`), and shift right arithmetic (`sra`).

<p align="center">
   <img src="https://i.imgur.com/5OTRh6n.png">
</p>

<details open>
  <summary>Contents</summary>

- [Background information](#background-information)
   - [Digital multi-bit capabilities](#digital-multi-bit-capabilities)
- [Boolean](#boolean)
   - [Multi-bit clarification](#multi-bit-clarification)
- [Add/Sub](#addsub)
   - [Subtraction](#subtraction)
   - [Outputs](#outputs)
- [Bidirectional Shifter](#bidirectional-shifter)
   - [Number of shift bits](#number-of-shift-bits)
      - [Not exactly the same as MIPS](#not-exactly-the-same-as-mips)
- [ALU](#alu)
   - [Z flag](#z-flag)
- [Submit your assignment](#submit-your-assignment)

</details>

## Background information

An arithmetic logic unit (ALU) is a digital circuit that performs arithmetic and logic operations. It is a fundamental building block of the central processing unit (CPU) of a computer. In this lab, `A` and `B` are 32-bit inputs, and `C` is the 32-bit output that is the result of some operation on `A` and `B` (see the ALUFN table above).

As with any coding problem, we should divide the problem into simpler subproblems. We will first implement the three sub-components Boolean, Add/Sub, and Bidirectional Shifter. Then, we will combine them to create the ALU.

You may move around the input and output components in the template files however you wish, but do not rename or delete them because doing so will cause the test cases to not work or fail. All `.dig` files contain test cases that you can run to check your work.

Remember to use tunnels.

### Digital multi-bit capabilities

As mentioned, `A`, `B`, and `C` are 32-bit. That is, `A` is $A_{31}A_{30}\ldots A_0$, which could be represented as 32 separate 1-bit input components, which would each be connected to at least 1 wire (so, at least 32 wires would be necessary). Because this is clearly inconvenient, we would rather represent `A` as a single 32-bit input and draw a single wire from it that represents 32 bits. This is depicted in the ALU diagram, where a `/` that crosses a wire denotes that the wire represents multiple bits. Digital allows us to do the same by setting an input component's data bits to 32. Then, the input's value and the value on the wire are 32-bit.

<p align="center">
   <img src="https://i.imgur.com/fv2uGfc.png">
</p>

<p align="center">
   <img src="https://i.imgur.com/zveMfKD.png">
</p>

When working with multi-bit data in Digital, you need to use the Splitter/Merger component to access individual bits or combine individual bits into a single wire. You will need to use this in several places in this lab. Please see details about Splitter/Merger in [this document](https://github.com/COMP311/useful_digital_components?tab=readme-ov-file#splittermerger), and you may do the optional ungraded exercise there, which includes a test case, to check your understanding.

## Boolean

In [boolean.dig](boolean.dig), implement a Boolean unit that computes the following bitwise operations on `A` and `B` based on the `Bool` control bits:

| Bool | Operation |
|:----:|:---------:|
|00|`A & B`|
|01|`A \| B`|
|10|`A ^ B`|
|11|`!(A \| B)`|

Note that the only control bits that are inputs to the Boolean unit are the `Bool` bits, per the ALU diagram. This is because in the ALUFN table, only the `Bool` bits determine the logic operation.

When you use a logic gate, set its Data Bits to 32 by right-clicking the gate. This will allow you to connect the 32-bit inputs `A` and `B` to the gate inputs to perform the bitwise operation on them.

Because the output of the logic gates are 32-bit, make sure that the multiplexer is also set to 32 data bits. How many selector bits are needed?

### Multi-bit clarification

This multiple data bit behavior is an abstraction. To see how it works, consider how we would implement an AND gate with 2 data bits and 2 inputs:

<p align="center">
   <img src="https://i.imgur.com/o40mVFK.png" width="50%" height="50%">
</p>
<p align="center"><i>Abstract <code>AND</code> with 2 data bits and 2 inputs</i></p>

If you fill out the truth table and determine expressions for <code>C<sub>1</sub></code> and <code>C<sub>0</sub></code> (e.g., by K-map), you'll see that $C_1=A_1B_1$ and $C_0=A_0B_0$. That is, Digital's AND gate with 2 data bits can be implemented with two normal AND gates, each with 1 data bit and 2 inputs.

<p align="center">
   <img src="https://i.imgur.com/xqiMbrZ.png">
</p>
<p align="center"><i><code>AND</code> with 2 data bits</i></p>

In short, recognize that in Digital, whenever we set a component to have $n$ data bits, it is an abstraction for having $n$ components, each with 1 data bit.

## Add/Sub

In [add_sub.dig](add_sub.dig), implement a 32-bit add/subtract circuit. It performs `A+B` when `Sub` is 0 and `A-B` when `Sub` is 1, per the ALUFN table. Use the Adder component (Components > Arithmetic > Adder), and set its data bits to 32 so that only one Adder component is needed, rather than 32 one-bit adder components.

### Subtraction

To implement subtraction, you are **not** allowed to use the Subtractor component, which is disallowed by the autograder code. To implement subtraction, use two's complement. Namely, `A-B = A + ~B + 1`. Invert the bits of `B` and add it to `A`, along with the `+1`.

To invert the bits of `B`, you will want to XOR it with `0xFFFFFFFF`, a 32-bit value. Thus, the Sign extender component (Components > Arithmetic > Sign extender) may be useful. It takes one input and outputs the value sign-extended to the desired bit width. Alternatively, you may simply "hardcode" `0xFFFFFFFF` as a constant value (Components > Wires > Constant value).

### Outputs

The outputs of the circuit are `Sum`, `Negative`, and `Overflow`.

`Sum` is the 32-bit arithmetic result of `A+B` or `A-B`.

`Negative` is 1 if `Sum` (when interpreted as a two's complement integer) is negative and 0 if `Sum` is positive. To access $\text{Sum}_{31}$, use a splitter with Input Splitting set to 32 and Output Splitting set to 31-31. The hyphen is necessary to specify a specific range of bits, which happens to be just the 31st bit in this case.

To determine `Overflow`, recall from COMP 211 that overflow occurs when adding two positive numbers and the result is negative or when adding two negative numbers and the result is positive. And, when the numbers have opposite signs, overflow never occurs. Thus, the equation to use is

$$\text{Overflow} = \overline{A_{31}}\space\overline{B_{31}}N + A_{31}B_{31}\overline{N}$$

$N$ is the `Negative` bit from before.

Because this equation works for addition and subtraction is performed via 2's complement, which involves only addition, this equation correctly detects overflow for subtraction as well. However, there is one important step. You must use $B_{31}$ after it has been inverted when subtraction is performed (or not inverted when addition is performed). That is, do not directly use $B_{31}$; instead, use the 31st bit of the output of the XOR gate, which we'll denote $X_{31}$. To access $A_{31}$ and $X_{31}$, use two splitters with the same settings as the one used to access $\text{Sum}_{31}$.

## Bidirectional Shifter

In [shifter.dig](shifter.dig), implement a bidirectional shifter unit that functions according to the following table:

| Bool | Operation |
|:----:|:---------:|
|00|`B << A`|
|01|Don't care, output anything|
|10|`B >> A`|
|11|`B >>> A`|

`<<` denotes shift left logical (`sll`), `>>` denotes shift right logical (`srl`), and `>>>` denotes shift right arithmetic (`sra`).

For this unit, use three Barrel shifter components (Components > Arithmetic > Barrel shifter). You may right-click it and click Help to see how it works. You may also hover your mouse over the `in` and `shift` inputs and `out` output to see information about them.

For one Barrel shifter, label it "sll" (or whatever you prefer), and set its data bits to 32, direction to left, and mode to logical. Configure the other two Barrel shifters accordingly.

These shifter components trivialize the Bidirectional Shifter unit. However, you'll encounter a problem.

### Number of shift bits

If you simply wire `B` into the Barrel shifter's `in` input and `A` into the `shift` input, Digital will tell you that it expects the shift amount to be a 6-bit value (assuming no other errors exist), whereas `A` is 32 bits. For a 32-bit value, regardless of the direction of the shift, there are 33 shift amounts (0-32) that result in a distinct output. Thus, 6 bits (which can represent 0-63) are needed. The extra shift amounts that can be represented (33-63) will all result in the same output as shifting by 32 (to confirm this, you can work through some examples).

To shift a 32-bit number, Digital requires 6 bits for shift amount (shamt), but `A` is 32 bits. How do we resolve this?

Because any shift amount greater than 32 will have the same result as shifting by 32, here's one solution to the problem:

```c
if (A > 32)
   shamt = 32;
else
   shamt = A[5:0];   // A_5 A_4 A_3 A_2 A_1 A_0
```

To implement the comparison `A > 32`, use the Comparator component (Components > Arithmetic > Comparator). Ensure that Signed Operation is off, which is the default setting.

To "hardcode" the constant 32, use Components > Wires > Constant value, and make sure to set the data bits correctly.

To access $A_{5:0}$, use a splitter.

For the `if/else` statement, it's up to you to figure out how to implement this in hardware. You already have the necessary knowledge for this.

Lastly, use the `Bool` bits to determine which Barrel shifter's (`sll`, `srl`, or `sra`) output is sent to the unit's output `C`. When the `Bool` bits are `01`, which does not correspond to a shift operation, `C` can be anything (e.g., an arbitrary constant value). The test cases do not check the value of `C` when the `Bool` bits are `01`.

#### Not exactly the same as MIPS

In COMP 211 and 311, you saw that for the MIPS R-type shift instructions (`sll`, `srl`, `sra`), shifting a 32-bit number requires 5 `shamt` bits (i.e., not 6, as required by Digital's Barrel Shifter). We would normally want to use 5 shift bits to be consistent with MIPS, but Digital's Barrel Shifter component requires 6 bits to shift a 32-bit number. Thus, the shifter circuit in this lab is not exactly the same as that of MIPS.

## ALU

You should pass all tests in the previous 3 files before starting this part.

Finally, in [alu.dig](alu.dig), implement the full ALU! This part should be simple because you have already implemented all of the components in the previous parts. Now, you need only connect them.

Here is our ALU diagram that we will copy exactly:

<p align="center">
   <img src="https://i.imgur.com/AdLVwIO.png">
</p>

To add the three subunits, click Components > Custom > "Component name". Add all three subunits (`add_sub`, `boolean`, and `shifter`). Then, add the two multiplexers, and set the data bits correctly. Finally, add a NOR gate with 1 data bit and 32 inputs.

Now, wire everything together exactly as shown in the diagram. The Add/Sub unit's `Negative` and `Overflow` outputs do not need to be connected to anything. Please use tunnels!

### Z flag

As shown in the above diagram, `Z` is computed by a big NOR gate on all bits of `Result`. If all bits are 0, `Z` is 1; otherwise, it is 0.

To access all 32 bits of `Result`, you should use a splitter with Input Splitting set to 32 and Output Splitting set to 1*32 (the asterisk is necessary). It should look like this:

<p align="center">
   <img src="https://i.imgur.com/PReYzwg.png">
</p>

`Z` is useful for comparison. For example, if we perform `A-B`, `Z` is 1 if `A == B` and 0 otherwise.

## Submit your assignment

See the [instructions for assignment submission](https://github.com/COMP311/submit-assignment).
