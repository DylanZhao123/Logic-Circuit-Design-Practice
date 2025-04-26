<!-- omit in toc -->
# Lab 0

In this lab, you'll learn how to use [Digital](https://github.com/hneemann/Digital), a digital logic designer and circuit simulator designed for educational purposes. You'll also learn about some basic conventions of circuits, such as power, ground, wires, mechanical switch, and light-emitting diode (LED).

<details open>
  <summary>Overview</summary>

- [Setup](#setup)
  - [SSH setup](#ssh-setup)
  - [Clone repo](#clone-repo)
  - [Install Digital](#install-digital)
    - [Windows](#windows)
    - [macOS/Linux](#macoslinux)
      - [Optional steps for convenience](#optional-steps-for-convenience)
- [Digital tutorial](#digital-tutorial)
- [Tips](#tips)
  - [Documentation](#documentation)
  - [Settings](#settings)
    - [Component tree view](#component-tree-view)
    - [Disable tunnel dialog](#disable-tunnel-dialog)
  - [Note for macOS users](#note-for-macos-users)
- [Example circuit](#example-circuit)
- [Mechanical AND gate](#mechanical-and-gate)
  - [Testing](#testing)
- [Submit your assignment](#submit-your-assignment)
</details>

## Setup

### SSH setup

As we did in COMP 211, we will clone GitHub repositories via SSH. If you have already generated an SSH key on your computer (not inside the COMP 211 container) and connected it to your GitHub account, skip to [Clone repo](#clone-repo).

To generate a new SSH key, follow [these instructions](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent#generating-a-new-ssh-key). Do only the steps in the section named "Generating a new SSH key".

On step 2, accept the default file location by pressing Enter. On step 3, when prompted for a passphrase, you may use no passphrase by simply pressing Enter twice.

Then, follow [these instructions](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account#adding-a-new-ssh-key-to-your-account) to add your SSH public key to your GitHub account.

### Clone repo

Run `git clone <link>`, where `<link>` is the SSH link (not HTTPS) to your Lab 0 repository.

<p align="center">
  <img src="https://i.imgur.com/eFycUZT.png">
</p>

### Install Digital

Digital allows us to design, simulate, and test circuits.

A Java Runtime Environment (at least JRE 8) is required to run Digital. You should already have this if you're using the same computer you used in COMP 210 or COMP 301. If not, search online for installation instructions for your specific OS and install. You can verify that it works and check its version with `java --version`.

To install Digital,

1. Go to [Digital's GitHub page](https://github.com/hneemann/Digital).
2. Click the green Download button at the top of the README (you may need to scroll down slightly).
3. Unzip the downloaded `.zip` file.
4. Move the extracted folder (not the `.zip` file) to an easily accessible location on your computer. You will need to access this frequently.

#### Windows

To start Digital, double-click `Digital.exe`.

#### macOS/Linux

To start Digital, run `java -jar PATH/TO/Digital.jar`, where `PATH/TO/Digital.jar` is the path to your `Digital.jar` file.

##### Optional steps for convenience

To start Digital without having to type the path to `Digital.jar`, alias the command. Run `echo "alias digital=\"java -jar ABSOLUTE_PATH_TO_DIGITAL_JAR\"" >> $HOME/.zshrc`, replacing `ABSOLUTE_PATH_TO_DIGITAL_JAR` with your **absolute** path to `Digital.jar`. Restart your terminal after running this command.

macOS's default shell is zsh, so this alias command is appended to `~/.zshrc`. If your default shell is not zsh (check with `echo $SHELL`), replace `.zshrc` with your shell's configuration file (e.g., `.bashrc` for bash).

You can now start Digital from any directory by running `digital`. You can also open a specific circuit file by running `digital PATH/TO/circuit.dig`.

<details>
  <summary>Fix for potential bug where Open menu does not display .dig files</summary>

If you encounter an uncommon bug where the Open menu does not display `.dig` files, open a `.dig` file by passing it as a command-line argument. For example, if you want to open the file `~/circuit.dig`, run `java -jar Digital.jar ~/circuit.dig` (or `digital ~/circuit.dig` if you did the optional steps above). You can drag a file from Finder to the terminal to automatically paste its absolute path.

</details>

## Digital tutorial

The first time you start Digital, you will be greeted with a built-in tutorial. If you do not see it, start it by clicking View > Start Tutorial.

Complete the tutorial, which shows you how to build and simulate a simple circuit.

## Tips

### Documentation

As shown in the tutorial, you can right-click a component to open a menu and configure settings for that component. The menu also contains a "Help" button that opens documentation for that component. Whenever you don't know what a component does or need to review, please refer to the documentation. You can also hover your mouse over a component to see a brief summary.

You may also download a PDF containing all documentation [here](https://github.com/hneemann/Digital/releases).

### Settings

To open settings, click Edit > Settings.

#### Component tree view

Click View > Component Tree View. This menu may make it easier for you to access components.

To make this menu open by default, click Edit > Settings > Component tree view is visible at startup.

#### Disable tunnel dialog

We will soon learn about the Tunnel component, which is very frequently used.

To make working with tunnels more convenient, disable the setting "Show dialog for automatic renaming of tunnels" (which is on by default).

### Note for macOS users

macOS users, if control-click does not work for you, try right clicking with two-finger tap. If this is not already enabled, then do the following:

1. Open your computer settings.
2. Search for "Trackpad" and press Enter.
3. Set secondary click to "Click or Tap with Two Fingers".

## Example circuit

In Digital, open [example.dig](example.dig). This is a simple circuit that contains a light-emitting diode (LED) and a mechanical switch.

Simulate the circuit by pressing the triangular Play button at the top. Then, click the switch to toggle it from open to closed, and note how this affects the LED.

To read about how an LED works, right-click the LED component and click "Help". You may also want to read about the other components Supply voltage (logic 1 or) and Ground (logic 0).

Nothing needs to be submitted for this part, but make sure you understand the circuit to be able to complete the next part.

## Mechanical AND gate

In Digital, open [and.dig](and.dig).

In this file, you'll slightly enhance the previous circuit. Specifically, create a circuit that acts like a "mechanical AND gate", where the LED turns on only if both switches are in the closed position. You need only add wires (i.e., wire the two switches in series). Don't use any logic gates or any additional components.

Don't delete or rename the switches. Our test cases in the green Test Case component require the switches to have the exact names given in the template file.

<details>
  <summary>Click here for instructions if you've already deleted or renamed the switches</summary>

If you have already deleted or renamed the switches, then either revert changes in your repo (`git restore .`) or add the switches back.

If you decide to add the switches back, the Switch component can be found at Components > Switches > Switch. Additionally, right-click a switch, select "Advanced", check "Switch behaves like an input", and name it `switch_0`. Do the same for the other switch, but name it `switch_1`.

</details>

### Testing

To manually verify that your circuit works according to the specification above, click the triangular Play button at the top and test your circuit manually.

To automatically test your circuit, click this button at the top to run our tests in the green Test Case component.

<p align="center">
  <img src="https://i.imgur.com/vTOPJbC.png">
</p>

You should then see a menu like this:

<p align="center">
  <img src="https://i.imgur.com/UMhr7Kd.png">
</p>

If you don't see this menu and receive an error, your circuit is invalid (similar to a compilation error when coding). Please read the error message and try to solve the issue.

The menu is essentially a truth table!

In this table, the `switch_0` and `switch_1` columns are inputs, and `LED` is the output that is checked. Each row represents a single test case. For each test case, we provide hardcoded inputs and the expected output. Digital then simulates the circuit with the given inputs and checks whether the output is correct or not. If you click on L2 or any other row, you'll see how this works.

If a test case fails, the menu would look like this:

<p align="center">
  <img src="https://i.imgur.com/apoaRFY.png">
</p>

In L4, the "E: Z / F: 1" means that when the circuit is given the inputs in L4, the expected output is Z, but the actual output is 1. For this circuit or more complicated circuits in the future, if you fail a test case, you could click it (here, L4) to see what happens in the circuit that causes the test failure.

**Note**: Z is a state that is neither logic 0 nor logic 1. You will learn more about this in a later lecture. All you need to know for now is that if the LED is off, its state is Z.

## Submit your assignment

See the [instructions for assignment submission](https://github.com/COMP311/submit-assignment).
