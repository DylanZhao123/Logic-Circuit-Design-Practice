<!-- omit in toc -->
# Lab 1

Now that we're familiar with Digital and combinational logic circuit design techniques (e.g., truth tables, sum of product (SOP) expressions, and SOP simplification using Karnaugh maps), it's time to take things to the next level! In this lab, you'll wire up a 7-segment LED display!

<details open>
  <summary>Contents</summary>

- [Seven-segment displays](#seven-segment-displays)
- [Truth table](#truth-table)
- [Construct circuit](#construct-circuit)
  - [Boolean equations](#boolean-equations)
  - [Learn about tunnels](#learn-about-tunnels)
  - [Create circuit in Digital](#create-circuit-in-digital)
    - [Testing](#testing)
    - [Tips](#tips)
- [Submit your assignment](#submit-your-assignment)
</details>

## Seven-segment displays

Seven-segment displays are widely used in digital clocks, electronic meters, basic calculators, and other electronic devices that display numerical information.

![seven segment display](https://user-images.githubusercontent.com/55986131/150591335-d79d4442-78be-4984-b9a2-df3d0044a3dc.png)

"Seven-segment" refers to the 7 LED's that turn on and off depending on the number or letter. This 7-segment display can display any hexit: the digits 0-9 and the letters A-F.

In this lab, we will create a combinational logic circuit with a 4-bit binary input (i.e., a hexit). The circuit will then display the hexit on the 7-segment display by outputting the correct signals to the 7 LED's. For example, if the input is `0b0001`, the circuit will turn on the b and c segments and turn off the rest to display the number 1. In general, 4 Boolean inputs are decoded to 7 Boolean outputs that are used to display a hexit (0-F).

The image below shows the name of each segment (F<sub>a</sub>, F<sub>b</sub>, F<sub>c</sub>, F<sub>d</sub>, F<sub>e</sub>, F<sub>f</sub>, F<sub>g</sub>) on the display:

<p align="center">
  <img src="https://user-images.githubusercontent.com/55986131/150592119-b54a65cd-a2a4-4478-9791-e2ce7881bda9.png" width="150">
</p>

The truth table below is crucial for constructing this circuit. We have filled out one row for you as an example. Specifically, when the input is `0b0000` (i.e., A = 0, B = 0, C = 0, D = 0), the digit 0 should be displayed. Based on the picture, we see that to display the digit 0, segments F<sub>a</sub> - F<sub>f</sub> must be 1, and F<sub>g</sub> must be 0.

<p align="center">
  <img src="https://i.imgur.com/vXky736.png" width="290">
</p>

As another example and to reduce work, we have also filled out the column for F<sub>a</sub>. In each row, if displaying the hexit requires the F<sub>a</sub> segment to be on, then F<sub>a</sub> = 1; else, F<sub>a</sub> = 0.

## Truth table

Before constructing the circuit in Digital, you must first complete the rest of the truth table.

Open [truth_table.csv](truth_table.csv) in your preferred CSV editor, and fill in the rest of the truth table. In each row, determine which of the 7 LED's need to be on (1) or off (0) to display the given number or letter.

When you are done, please push your changes and submit to Gradescope to check whether or not it is correct. If you have an incorrect truth table, your circuit in the next part will be incorrect!

## Construct circuit

Now that we've constructed the truth table, it's time to build the circuit! Before we open Digital, however, you need to do some planning.

### Boolean equations

Using the completed truth table, create simplified Boolean equations for output segments F<sub>a</sub> - F<sub>g</sub>. When you are done, you should have 7 simplified Boolean equations, one for each segment in the display.

To create simplified equations given this truth table, which approach is easier: SOP and simplification with Boolean identities or K-maps? Note that if your equations are not simplified, it will be harder to create the circuit in Digital.

### Learn about tunnels

Before you construct the circuit in Digital, you should first learn about the Tunnel component. This will save you a lot of time (creating and debugging) by making your circuit wiring cleaner.

For example, here are two circuits, one without tunnels and one with tunnels. They are logically equivalent, but the latter is clearly easier to construct, read, and debug.

<p align="center">
  <img src="https://i.imgur.com/yhsAHK1.png">
</p>

<p align="center">
  <img src="https://i.imgur.com/I8YNwgt.png">
</p>

You may learn about the Tunnel component in [Useful Digital components](https://github.com/COMP311/useful_digital_components?tab=readme-ov-file#tunnel).

### Create circuit in Digital

Now that we have 7 simplified Boolean equations, we can create the circuit in Digital.

Open [seven_seg.dig](seven_seg.dig) in Digital. You are provided 4 input components (A, B, C, D) and 7 output components (F<sub>a</sub> - F<sub>g</sub>). You are also provided the Seven-Segment Display component (Components > IO > Displays > Seven-Segment Display). You are **not** allowed to use the Seven-Segment Hex Display.

You may move around components as you wish, but do not change the names of any of the input or output components. If you do so, the Test Case component would not recognize the new name, and this would cause an error when you run the tests locally and when the tests are run on Gradescope.

In short, you need to wire up 7 subcircuits, one for each of your Boolean equations. The output of each subcircuit should connect to the corresponding input on the Seven-Segment Display and an Output component.

For example,

<p align="center">
  <img src="https://i.imgur.com/N79GNDk.png">
</p>

<p align="center">
  <img src="https://i.imgur.com/1tnoj8v.png">
</p>

You must connect each subcircuit output to the corresponding Output component (one of F<sub>a</sub> - F<sub>g</sub>) for testing purposes. Specifically, the Test Case component can read the value of each Output component to check whether each subcircuit is correct, but it cannot read the character displayed on the Seven-Segment Display.

The above image shows where to connect the output of each subcircuit to the Seven-Segment Display (e.g., F<sub>a</sub> connects to the top-left input, and the bottom-right input connects to ground).

Lastly, note in the above images that the names of components can contain subscript characters (e.g., F<sub>a</sub> instead of Fa). In the template file, all output labels use subscript characters. To use subscripts in labels, use underscore (`_`). For example, F<sub>a</sub> is written as `F_a`. To subscript more than one character, use braces (`{`, `}`). For example, F<sub>ab</sub> is written as `F_{ab}`.

#### Testing

See the [Lab 0 instructions](https://github.com/COMP311/lab-0?tab=readme-ov-file#testing) for testing a circuit in Digital.

#### Tips

- You may change the number of inputs for logic gates (e.g., AND, OR). For example, you could create a 3-input AND gate or a 4-input OR gate. To do so, right-click the gate to open its settings, and change "Number of Inputs". In this menu, you may also invert inputs on the gate itself (rather than adding a NOT gate).
- Make sure that when you cross wires, you don't connect them accidentally. If wires intersect and Digital displays a blue dot at the intersection, then the wires are connected. You may sometimes intend to do this, but just make sure that when it happens, you're doing it on purpose.

## Submit your assignment

See the [instructions for assignment submission](https://github.com/COMP311/submit-assignment).
