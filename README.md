# Verilog Codes
Some Icarus Verilog codes written during Lab Sessions of **Computer Architecture** Course at **BITS Pilani**.

## Running a file 

- Compile the verilog file (one with.v extension) using following command
```verilog
iverilog -o filename.vvp filename.v
```
- To see output using $monitor statements run following command
```verilog
vvp filename.vvp
```
- To get graphical waveform output, make sure to add following lines in every test branch
```verilog
initial
    begin
        $dumpfile("filename.vcd");
        $dumpvars;
    end
```

- To see graphical waveform output
```verilog
gtkwave filename.vcd
```

- To include a header file in your program
```verilog
`include "modulename.v"
```

### **Important Points**
1. By default, go for `output reg` and `input wire`. In the testbench, the inputs will be just `reg` and outputs will be just `wire`. Beware of using `output reg` for structural modelling.
2. When there's a `reg` that needs to be used to store and change the value of an `input wire`, with behavioral modelling, use the `always @ (*)` block to contain the assignment of that `reg`. [Example](https://stackoverflow.com/questions/14443608/assigning-value-to-a-register-in-a-module-instance-in-verilog)
3. All `$` system tasks and functions must end with a `;`.
4. Use non-blocking assignment, `<=`, in cases where counters or shift registers are to be designed.
5. The output ‘x’ indicates that the signal is still unkown and being evaluated.
6. In combinational circuits ‘z’ in the output means the signals are not connected properly.

### References :
1. *Verilog HDL by Samir Palnitkar*

### Warning :
* **All files on this repository are for educational purpose with no intentions of promoting unfair means in any evaluative component**.