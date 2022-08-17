# iiitb_ptvm : Parking Ticket Vending Machine
A parking ticket vending machine simulated in verilog. The coin accepts Rs 5 and 10 coins, and dispenses a Rs 20 ticket when coins of appropriate value are inserted.

## Parking Ticket Vending Machine: an introduction
The machine is implemented using principles of Finite State Machine, which hop across different states while keeping track of the input coins.
For a more thorough discussion, consider reading this: 
https://www.google.com/url?sa=t&rct=j&q=&esrc=s&source=web&cd=&cad=rja&uact=8&ved=2ahUKEwjf-86YzZr5AhUGgVYBHfVIAuAQFnoECAcQAQ&url=http%3A%2F%2Fwww.csun.edu%2F~ags55111%2Fdoc%2F526%2F526report.pdf&usg=AOvVaw3NuGRaAizOTMxRLgdB-8qI


## FSM State diagram
![](photo1658686000.jpeg)

## About iverilog 
Icarus Verilog is an implementation of the Verilog hardware description language.
## About GTKWave
GTKWave is a fully featured GTK+ v1. 2 based wave viewer for Unix and Win32 which reads Ver Structural Verilog Compiler generated AET files as well as standard Verilog VCD/EVCD files and allows their viewing

## How to simulate on host
Use the following commands:
'''
$supo apt install -y git
$sudo apt install iverilog
$sudo apt install gtkwave
$git clone suysh-msra/iiitb_pvtm
$iverilog iiitb_pvtm.v
$vvp ./a.out
$gtkwave ticketvending.vcd
'''
## Input/Output waveforms
![plotted using gtkwave](waveform.png)
Note that these are not the final waveforms, some changes are required to make the machine dispense change at the end of transaction, if required.

# PreSynthesis

To clone the repository, download the netlist files and simulate the results, Enter the following commands in your terminal:

```
 $ git clone https://github.com/suysh-msra/iiitb_ptvm

 $ cd iiitb_ptvm
 
 $ iverilog -o iiitb_ptvm_out.out iiitb_ptvm.v iiitb_ptvm_tb.v
 
 $ ./iiitb_ptvm_out.out
 
 $ gtkwave iiitb_ptvm_vcd.vcd
```
![some txt](suyash_pre_synth.png)

# PostSynthesis

```
$ yosys

yosys> read_liberty -lib ../lib/sky130_fd_sc_hd__tt_025C_1v80.lib

yosys> read_verilog iiitb_ptvm.v

yosys> synth -top iiitb_ptvm

yosys> dfflibmap -liberty ../lib/sky130_fd_sc_hd__tt_025C_1v80.lib

yosys> abc -liberty ../lib/sky130_fd_sc_hd__tt_025C_1v80.lib

yosys> stat

yosys> show

yosys> write_verilog iiitb_ptvm_netlist.v

$ iverilog -DFUNCTIONAL -DUNIT_DELAY=#1 ../verilog_model/primitives.v ../verilog_model/sky130_fd_sc_hd.v iiitb_ptvm_netlist.v iiitb_ptvm_tb.v

$ ./a.out

$ gtkwave iiitb_ptvm_vcd.vcd
```
## Applications
Besides using the machine for dispensing tickets, the code can be modified to simulate other, similar FSMs.



## Contributors
- Suyash Misra
- Kunal Ghosh
- Yash Kothari
- Tejas BN
- Aman Prajapati
- Pankaj

## Acknowledgments


- Kunal Ghosh, Director, VSD Corp. Pvt. Ltd.

## Contact Information

- Suyash Misra, Postgraduate Student, International Institute of Information Technology, Bangalore  suysh.msra@gmail.com
- Kunal Ghosh, Director, VSD Corp. Pvt. Ltd. kunalghosh@gmail.com
