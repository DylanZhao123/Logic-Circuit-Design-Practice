<!-- omit in toc -->
# Lab 3

Now that we're comfortable with building combinational logic circuits in Digital, it's time to build some sequential logic circuits. In this lab, you'll build a 4-bit enabled register (a 32-bit version is necessary in MIPS architecture) and a 3-bit counter circuit that is synchronized to a clock.

<details open>
  <summary>Overview</summary>

- [Register](#register)
   - [Example](#example)
   - [Enabled D flip-flop](#enabled-d-flip-flop)
   - [Enabled register implementation](#enabled-register-implementation)
- [3-bit counter](#3-bit-counter)
   - [Sequential logic](#sequential-logic)
   - [State diagram](#state-diagram)
   - [T flip-flop](#t-flip-flop)
      - [Notes](#notes)
   - [State truth table](#state-truth-table)
   - [K-maps](#k-maps)
   - [Implementation](#implementation)
      - [Testing](#testing)
   - [Fun](#fun)
      - [Testing](#testing-1)
- [Submit your assignment](#submit-your-assignment)
</details>

## Register

Recall from COMP 211 that in MIPS architecture, there are 32 registers that each hold a 32-bit value. In this section, to see how a register is implemented and gain experience working with D flip-flops, you'll create a 4-bit register.

### Example

Open [example_register.dig](example_register.dig) in Digital. You won't have to modify this file. It's just an example so you can see how a register works. `D` and `Q` are 4-bit, and the register is 4-bit. The `CLK` input is a Clock Input component, not a regular Input component, but it behaves the same way.

Start simulation by pressing the Play button. Note that `Q` is initially 0. That is, the register initially holds the value 0.

Set `en` (short for "enable") to 1.

Now, change the value of `D` to 7 (arbitrary value). Notice that the output `Q` does not change yet. If you click `CLK`, you will now see 7 appear at `Q`. Because we provided a rising edge by toggling `CLK` 0 -> 1, we wrote the value 7 to the register, so 7 is visible at the output.

Try writing a different arbitrary value to the register. Change `D` to any value that isn't `Q`'s current value. Assuming `CLK`'s value is still 1, will you have to click `CLK` once or twice to see the new value at `Q`?

You should recognize that this behavior (when `en = 1`) is identical to that of a D flip-flop. Specifically, recall from lecture slides that for a D flip-flop, `Q` follows `D` on a rising-edge event (assuming the flip-flop is rising-edge triggered). The only difference is that this register uses a 4-bit value for `D` and `Q`, not 1-bit.

Now reset `en` to 0. Change `D` to any value that isn't `Q`'s value. Now, no matter how many times you click `CLK`, `Q` will not change. This is because we have disabled the register so that it does not respond to any clock event (rising edge, falling edge, active high, or active low).

This enable/disable functionality is useful when we wish to write a new value to the register only some of the time rather than on every rising edge. More specifically, it is useful in MIPS architecture, which will be covered later in the course.

Now, we'll implement an enabled register ourselves.

### Enabled D flip-flop

We first need to create an enabled D flip-flop (rising-edge triggered). It should behave as specified in the [previous section](#example). Specifically, if `en = 1`, it should behave exactly the same as a normal D flip-flop (`Q` follows `D` on a rising-edge event). If `en = 0`, it ignores the clock, and its output `Q` always retains its value.

In [enabled_d_flip_flop.dig](enabled_d_flip_flop.dig), implement an enabled D flip-flop.

You can find the D flip-flop component (no `en` input) in Components > Flip-Flops > D-Flip-flop. You may need additional component(s), such as logic gate(s), multiplexer(s), etc.

The intended solutions are not complicated. Both intended solutions involve only one additional component.

Do not continue to the next section "Enabled register implementation" until you pass all tests in this file.

### Enabled register implementation

In [enabled_register.dig](enabled_register.dig), implement a 4-bit enabled register that behaves exactly the same as the [example register](#example) described above.

The inputs and outputs in this file are the same as the ones in the example register and are described [above](#example).

You can insert an enabled D flip-flop component by clicking Components > Custom > enabled_d_flip_flop. How many are needed? Also, you will have to use splitter(s).

Lastly, you are not allowed to use the Register or Register File components in this file.

## 3-bit counter

Now we'll build a 3-bit counter circuit that is synchronized to a clock.

### Sequential logic

Before implementing the circuit, we first need to know a bit more about sequential logic. Here's a blurb from Wikipedia that explains the usefulness of sequential logic circuits:

> Sequential logic is a type of logic circuit whose output depends on the present value of its input signals and on the sequence of past inputs, the input history. This is in contrast to combinational logic, whose output is a function of only the present input. That is, sequential logic has state (memory) while combinational logic does not.

Sequential logic circuits are the backbone of the construction of finite-state machines (covered in COMP 455). For example, see the FSM below that represents a TV remote with channel up and channel down buttons.

<p align="center">
   <img src="https://i.imgur.com/U80EPMc.png">
</p>

Each circle in the FSM represents a state, a condition that the circuit can be found in. In the circle, we describe the state (in this example, channel 0, 1, 2, or 3). If this FSM were implemented in a sequential logic circuit, the state would also be considered the output of the circuit (i.e., the possible circuit outputs are 0, 1, 2, and 3). Each arrow represents a transition from one state to another, except for the leftmost arrow on channel 0 that denotes that the starting state is channel 0.

When there is an "up" or "down" input is given, the sequential logic of the circuitry calculates the new channel from the input and the current channel (0, 1, 2, or 3). In other words, the output depends on the current channel (i.e., the current state, which was determined by past inputs). Thus, no combinational logic circuit could implement this FSM because a combinational circuit's output depends only on the present inputs (i.e., a combinational circuit does not have memory).

Our goal for this lab is to create a 3-bit counter that counts upwards from 0 to 7 and can pause, and we must use an FSM to represent it. Thus, a sequential logic circuit is necessary.

### State diagram

The first step in designing our 3-bit counter is to design a state diagram for it, which is shown below.

<p align="center">
   <img src="https://user-images.githubusercontent.com/55986131/152058876-a2b1557f-3fd8-4186-a56d-1e167032782b.png" width="350">
</p>

We will use a clock in our circuit, and the transitions in this diagram will occur only on rising edges. On each rising edge, if the input ($\text{Up}$) is 0, we stay on the same state; otherwise, we advance to the next state. Since the state stays the same when $\text{Up} = 0$ and advances when $\text{Up} = 1$, the circuit has two functionalities: pause and advance.

Here is an example. Suppose our FSM starts at the 000 state. If $\text{Up} = 1$ and a rising edge occurs, the state transitions to 001. If $\text{Up}$ continues to be 1, the state transitions to 010 on the next rising edge and so on. But if $\text{Up} = 0$, the state remains the same on the next rising edge.

For example, here is a waveform diagram for the counter circuit that was generated by Digital. $Q_2$, $Q_1$, and $Q_0$ are the three bits that represent the state of the counter. For example, if the state is 001, $Q_2=0$, $Q_1=0$, and $Q_0=1$.

<p align="center">
   <img src="https://i.imgur.com/VFnvlXx.png" width="700">
</p>

While $\text{Up} = 1$ at the beginning and $\text{CLK}$ pulses consistently, the state transitions 000 -> 001 -> ... -> 111, and each state transition occurs on a rising edge. Near the end, when $\text{Up} = 0$, the state does not change on the rising edge. Finally, at the end, when $\text{Up} = 1$ again but there is not a rising edge (intentional), the state does not change.

For this waveform, the counter advances from the start time until $\text{Up} = 0$. From that point until the end, the counter is paused.

### T flip-flop

<p align="center">
   <img src="https://user-images.githubusercontent.com/55986131/152062532-b26f8108-c13f-492c-a139-fd416d4ab737.png">
</p>

There are many types of flip-flops (e.g., D, J/K, and T). All flip-flops have a clock input, but they perform different actions in response to the non-clock input(s). We'll use T flip-flops for this circuit. It could also be implemented with D and/or J/K flip-flops, but we choose to use T flip-flops here because doing so will make the Boolean equations simpler for this circuit (not every circuit).

The “T” in “T flip-flop” stands for “toggle," as you will see in its truth table below. $Q$ is the current $Q$ value (before clock event), $Q^{\ast}$ is the next $Q$ value (after clock event), and $T$ is an input to the T flip-flop (the one that isn't the clock input).

| T | Q | Q* |
|:---:|:---:|:----:|
|0|0|0|
|0|1|1|
|1|0|1|
|1|1|0|

If $T = 1$, $Q^\ast$ will be the negation of $Q$ (i.e., toggles 0 -> 1 or 1 -> 0). Otherwise, $Q^\ast$ remains the same as $Q$.

To check whether you understand this, we recommend playing around with a T flip-flop (Components > Flip-Flops > T-flip-flop) in a new Digital file, similar to how we tested the [example register](#example) above. You'll also need 1 Input component, 1 Clock Input (Components > IO > Clock Input) component, and 1 Output component.

#### Notes

If we assume the flip-flop is rising-edge triggered (i.e., the clock event is a rising edge), the table above is a simplification of this full table:

| CLK | T | Q | Q* |
|:-:|:---:|:---:|:----:|
|rising edge|0|0|0|
|rising edge|0|1|1|
|rising edge|1|0|1|
|rising edge|1|1|0|
|falling edge, active high, or active low|x|0|0|
|falling edge, active high, or active low|x|1|1|

The assumption removes the need for the CLK column and the last two rows because the assumption makes the information in those places obvious. So, the simplified truth table omits the extra information.

Lastly, note that $Q^{\ast}$ is not the same as $\bar{Q}$ in the T flip-flop circuit diagram above. $\bar{Q}$ above is simply the negation of $Q$, and it is not necessary to use it for this assignment.

### State truth table

As you can see in the above, a T flip-flop stores 1 bit of information. So, for our 3-bit counter, we need 3 T flip-flops.

Each flip-flop's $Q$ output is one bit of our 3-bit output $Q_2Q_1Q_0$. Abstractly, the circuit looks like the below image. The only missing parts are the logic that determine the values of $T_2$, $T_1$, and $T_0$.

<p align="center">
   <img src="https://i.imgur.com/jUKqoyR.png">
</p>

To implement the circuit, we first need to create a state truth table that represents the state diagram, similar to how we implement combinational logic circuits.

Here are the columns and first two rows:

|$Q_2$|$Q_1$|$Q_0$|Up|$Q_2^{\ast}$|$Q_1^{\ast}$|$Q_0^{\ast}$|$T_2$|$T_1$|$T_0$|
|:---:|:---:|:---:|:--:|:---:|:---:|:---:|:---:|:---:|:---:|
|0|0|0|0|0|0|0|0|0|0|
|0|0|0|1|0|0|1|0|0|1|

$Q_2Q_1Q_0$ is the current state, and $Q_2^{\ast}Q_1^{\ast}Q_0^{\ast}$ is the next state. $T_2T_1T_0$ are the three inputs to the three T flip-flops that will cause the circuit to transition from the current state $Q_2Q_1Q_0$ to the next state $Q_2^{\ast}Q_1^{\ast}Q_0^{\ast}$.

Let's go through the first two rows.

If $Q=000$ and $\text{Up}=0$, then $Q^{\ast}=000$ (counter is paused, so the state must not change). Notice that all bits stay the same (no toggle). To achieve this, $T_2=T_1=T_0=0$.

If $Q=000$ and $\text{Up}=1$, then $Q^{\ast}=001$ (counter state must advance on the rising edge). Notice that bit 0 (LSB) toggles, and bits 1 and 2 remain the same. To achieve this, $T_0=1$ and $T_1=T_2=0$.

In [state_truth_table.csv](state_truth_table.csv), we provide all $Q_2Q_1Q_0$ and $\text{Up}$ values, and the first two rows that were explained above are filled out for you. You need to fill in the $Q_2^{\ast}Q_1^{\ast}Q_0^{\ast}$ and $T_2T_1T_0$ values in the remaining rows.

When done, submit to Gradescope to check your state truth table. If it is incorrect, your equations and circuit won't work!

### K-maps

After completing the truth table and confirming that it is correct on Gradescope, we need to find Boolean equations for the circuit. We need three Boolean equations, one for each of $T_2$, $T_1$, and $T_0$.

To obtain simplified equations, draw K-maps for $T_2$, $T_1$, and $T_0$ (3 total). The inputs for the K-maps are $Q_2$, $Q_1$, $Q_0$, and $\text{Up}$. Note that $Q_2$, $Q_1$, and $Q_0$ are also outputs of the circuit. That is, this circuit has feedback (outputs are fed back as inputs to the circuit).

Each K-map should look like this (the order of the K-map inputs doesn't matter):

|$Q_2$ $Q_1$ \ $Q_0$ $\text{Up}$|00|01|11|10|
|-|-|-|-|-|
|**00**|||||
|**01**|||||
|**11**|||||
|**10**|||||

Using the K-maps, find simplified Boolean equations for $T_2$, $T_1$, and $T_0$. The equations should be simple.

### Implementation

In [counter.dig](counter.dig), implement the 3-bit counter circuit.

You can find the T flip-flop component in Components > Flip-Flops > T-Flip-Flop. Ignore the $\overline{Q}$ output; you shouldn't need it.

Remember, this is a sequential circuit, so there should be feedback (i.e., the $Q_2Q_1Q_0$ outputs are fed back as inputs to the circuit). This is how the circuit "remembers" its previous state to determine the next state.

#### Testing

You can test the circuit as you normally would (run tests).

You can also start simulation, set `Up` to 1, and click `CLK` repeatedly to see the circuit count up.

Additionally, before simulating, you can right-click the Clock Input component and toggle on "Start real time clock" (this does not affect the tests). Then, when simulating, you should see the $Q$ bits count up automatically in sync with the clock.

Do not continue to the next section "Fun" until you pass all tests in this file.

### Fun

Now the fun part!

Copy your completed (i.e., passes all tests) Lab 1 file `seven_seg.dig` to this repo (maybe you see where we're going with this). If you do not have a working solution, inform us via Piazza, and we will provide you with one. Do not change the file's name.

Open `seven_seg.dig` in Digital and insert this lab's counter circuit by clicking Components > Custom > counter. Place it near the inputs `B`, `C`, and `D`. We will now replace those inputs with the counter outputs.

Delete the input components `B`, `C`, and `D` but not any wires/tunnels they're connected to. Now connect the counter outputs <code>Q<sub>2</sub></code>, <code>Q<sub>1</sub></code>, and <code>Q<sub>0</sub></code> to the wires/tunnels that `B`, `C`, and `D`, respectively, were connected to.

Insert a Clock Input component (Components > IO > Clock Input) and connect it to the counter's `CLK` input. Right-click the Clock Input, and label it "CLK" (case-sensitive). Also, toggle on "Start real time clock." For the counter's `Up` input, connect it to logic high (Components > Wires > Supply voltage).

#### Testing

When you start the simulation, you should see the 7-segment display count through the hexits 0-7 automatically in sync with the clock. If you set the input `A` (MSB) to 1, it should instead count through the hexits 8-f.

Additionally, you can run tests. However, the old tests in the file will error because we removed some input components. When you submit to Gradescope, our tests (not the ones in your file) will be used, so this won't matter in Gradescope. But, to test locally (for debugging), you can paste our tests into the green Test Case component at the top by right-clicking the component, clicking "Edit", deleting what's already there, and pasting this text:

```text
CLK A F_a F_b F_c F_d F_e F_f F_g
# 0-7
0 0 1 1 1 1 1 1 0
C 0 0 1 1 0 0 0 0
C 0 1 1 0 1 1 0 1
C 0 1 1 1 1 0 0 1
C 0 0 1 1 0 0 1 1
C 0 1 0 1 1 0 1 1
C 0 1 0 1 1 1 1 1
C 0 1 1 1 0 0 0 0
C 0 1 1 1 1 1 1 0

# 8-f
0 1 1 1 1 1 1 1 1
C 1 1 1 1 1 0 1 1
C 1 1 1 1 0 1 1 1
C 1 0 0 1 1 1 1 1
C 1 0 0 0 1 1 0 1
C 1 0 1 1 1 1 0 1
C 1 1 0 0 1 1 1 1
C 1 1 0 0 0 1 1 1
C 1 1 1 1 1 1 1 1
```

## Submit your assignment

See the [instructions for assignment submission](https://github.com/COMP311/submit-assignment).
