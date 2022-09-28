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
![some more txt](suyash_post_synth.png)
![even more txt](suyash_netlist.png)

# Creating a Custom Inverter Cell

Open Terminal in the folder you want to create the custom inverter cell.

```
$ git clone https://github.com/nickson-jose/vsdstdcelldesign.git

$ cd vsdstdcelldesign

$  cp ./libs/sky130A.tech sky130A.tech

$ magic -T sky130A.tech sky130_inv.mag &
```

![1](https://user-images.githubusercontent.com/62461290/187424346-c798a1a0-3e8b-43c8-a14a-7fc75e51ef2a.png)<br>

The above layout will open. The design can be verified and various layers can be seen and examined by selecting the area of examination and type `what` in the tcl window.

To extract Spice netlist, Type the following commands in tcl window.

```
% extract all

% ext2spice cthresh 0 rthresh 0

% ext2spice
```
`cthresh 0 rthresh 0` is used to extract parasitic capacitances from the cell.<br>

![2](https://user-images.githubusercontent.com/62461290/187435606-af09735d-64bf-4623-a4bf-e3bae9a2bd56.png)

The spice netlist has to be edited to add the libraries we are using, The final spice netlist should look like the following:

```
* SPICE3 file created from sky130_inv.ext - technology: sky130A

.option scale=0.01u
.include ./libs/pshort.lib
.include ./libs/nshort.lib


M1001 Y A VGND VGND nshort_model.0 ad=1435 pd=152 as=1365 ps=148 w=35 l=23
M1000 Y A VPWR VPWR pshort_model.0 ad=1443 pd=152 as=1517 ps=156 w=37 l=23
VDD VPWR 0 3.3V
VSS VGND 0 0V
Va A VGND PULSE(0V 3.3V 0 0.1ns 0.1ns 2ns 4ns)
C0 Y VPWR 0.08fF
C1 A Y 0.02fF
C2 A VPWR 0.08fF
C3 Y VGND 0.18fF
C4 VPWR VGND 0.74fF


.tran 1n 20n
.control
run
.endc
.end
```

Open the terminal in the directory where ngspice is stored and type the following command, ngspice console will open:

```
$ ngspice sky130_inv.spice 
```
![ngspice](https://user-images.githubusercontent.com/84946358/188592375-b361e9d8-b47e-4936-8175-64bc392fa6dc.png)


Now you can plot the graphs for the designed inverter model.

```
-> plot y vs time a
```

![4](https://user-images.githubusercontent.com/62461290/187437163-988dac40-0bd4-4ef6-abba-8528bad54659.png)<br>

Four timing parameters are used to characterize the inverter standard cell:<br>

1. Rise time: Time taken for the output to rise from 20% of max value to 80% of max value<br>
        `Rise time = (2.23843 - 2.17935) = 59.08ps`
2. Fall time- Time taken for the output to fall from 80% of max value to 20% of max value<br>
        `Fall time = (4.09291 - 4.05004) = 42.87ps`
3. Cell rise delay = time(50% output rise) - time(50% input fall)<br>
        `Cell rise delay = (2.20636 - 2.15) = 56.36ps`  
4. Cell fall delay  = time(50% output fall) - time(50% input rise)<br>
        `Cell fall delay = (4.07479 - 4.05) = 24.79ps`
        
To get a grid and to ensure the ports are placed correctly we can use
```
% grid 0.46um 0.34um 0.23um 0.17um
```

![5](https://user-images.githubusercontent.com/62461290/187439583-b2226424-4db2-419f-8e6b-ff1e4d365adb.png)


To save the file with a different name, use the folllowing command in tcl window
```
% save sky130_vsdinv.mag
```

Now open the sky130_vsdinv.mag using the magic command in terminal
```
$ magic -T sky130A.tech sky130_vsdinv.mag
```
In the tcl command type the following command to generate sky130_vsdinv.lef
```
$ lef write
```
A sky130_vsdinv.lef file will be created.


# Layout

## Preparation
The layout is generated using OpenLane. To run a custom design on openlane, Navigate to the openlane folder and run the following commands:<br>
```
$ cd designs

$ mkdir iiitb_ptvm

$ cd iiitb_ptvm

$ mkdir src

$ touch config.json

$ cd src

$ touch iiitb_ptvm.v
```

The iiitb_ptvm.v file should contain the verilog RTL code you have used and got the post synthesis simulation for. <br>

Copy  `sky130_fd_sc_hd__fast.lib`, `sky130_fd_sc_hd__slow.lib`, `sky130_fd_sc_hd__typical.lib` and `sky130_vsdinv.lef` files to `src` folder in your design. <br>

The final src folder should look like this: <br>

![f2](https://user-images.githubusercontent.com/62461290/187058789-46914626-3965-41c8-8336-cff2ed949889.png) <br>

The contents of the config.json are as follows. this can be modified specifically for your design as and when required. <br>

As mentioned by Kunal sir dont use defined `DIE_AREA` and `FP_SIZING : absolute`, use `FP_SIZING : relative`
```
{
    "DESIGN_NAME": "iiitb_ptvm",
    "VERILOG_FILES": "dir::src/iiitb_ptvm.v",
    "CLOCK_PORT": "clkin",
    "CLOCK_NET": "clkin",
    "GLB_RESIZER_TIMING_OPTIMIZATIONS": true,
    "CLOCK_PERIOD": 10,
    "PL_TARGET_DENSITY": 0.7,
    "FP_SIZING" : "relative",
    "pdk::sky130*": {
        "FP_CORE_UTIL": 30,
        "scl::sky130_fd_sc_hd": {
            "FP_CORE_UTIL": 20
        }
    },
    
    "LIB_SYNTH": "dir::src/sky130_fd_sc_hd__typical.lib",
    "LIB_FASTEST": "dir::src/sky130_fd_sc_hd__fast.lib",
    "LIB_SLOWEST": "dir::src/sky130_fd_sc_hd__slow.lib",
    "LIB_TYPICAL": "dir::src/sky130_fd_sc_hd__typical.lib",  
    "TEST_EXTERNAL_GLOB": "dir::../iiitb_ptvm/src/*"


}
```



Save all the changes made above and Navigate to the openlane folder in terminal and give the following command :<br>

```
$ make mount 
```

After entering the openlane container give the following command:<br>
```
$ ./flow.tcl -interactive
```
![2](https://user-images.githubusercontent.com/62461290/186196149-b595f203-a711-46cc-8949-39bee6de552e.png)

This command will take you into the tcl console. In the tcl console type the following commands:<br>
![container](https://user-images.githubusercontent.com/84946358/188596692-f07a7d5f-6dad-4691-8aa5-35148f53032b.png)

```
% package require openlane 0.9
```
![3](https://user-images.githubusercontent.com/62461290/186196154-c3caa53a-1199-45d1-8903-ba7a1f626c96.png)<br>
```
% prep -design iiitb_ptvm
```

The following commands are to merge external the lef files to the merged.nom.lef. In our case sky130_vsdiat is getting merged to the lef file <br>
```
set lefs [glob $::env(DESIGN_DIR)/src/*.lef]
add_lefs -src $lefs
```

The contents of the merged.nom.lef file should contain the Macro definition of sky130_vsdinv <br>
<br>


## Synthesis
```
% run_synthesis
```

### Synthesis Reports
Details of the gates used <br>
<br>
![synthesis](/1stq.png)

Setup and Hold Slack after synthesis<br>
<br>![sta](https://user-images.githubusercontent.com/84946358/188602467-f4ae52ac-468f-43ea-922e-56118dd63702.png)


<br>
```
Flop Ratio = Ratio of total number of flip flops / Total number of cells present in the design = 4/25 = 0.16
```
<br>
The sky130_vsdinv should also reflect in your netlist after synthesis <br>
<br>


## Floorplan
```
% run_floorplan
```

### Floorplan Reports
Die Area <br>
<br>![die area](https://user-images.githubusercontent.com/84946358/188603983-c593c1a4-5e3e-4c33-995d-96f49dbfd2d6.png)


<br>
Core Area <br>
<br>![core area](/images/core-area.png)

Navigate to results->floorplan and type the Magic command in terminal to open the floorplan <br>
```
$ magic -T /home/suyash/OpenLane/pdks/sky130A/libs.tech/magic/sky130A.tech read ../../tmp/merged.nom.lef def read iiitb_ptvm.def &
```
![14](https://user-images.githubusercontent.com/62461290/187059593-bdf6b441-9cb8-4838-a2a0-5638af1c7c02.png)<br>
<br>
Floorplan view <br>
<br>
![floorplan](images/Screenshot from 2022-09-28 01-01-23.png)
<br>
<br>
![15](https://user-images.githubusercontent.com/62461290/187059629-b135d6dd-dd77-4a0d-a322-6c8864a6210c.png)

## Placement
```
% run_placement
```
![16](https://user-images.githubusercontent.com/62461290/187059712-d8940d40-04f7-4eac-acf6-24ee71c79103.png)<br>

### Placement Reports
Navigate to results->placement and type the Magic command in terminal to open the placement view <br>
```
$ magic -T /home/suyash/OpenLane/pdks/sky130A/libs.tech/magic/sky130A.tech read ../../tmp/merged.max.lef def read iiitb_ptvm.def &
```

<br>
Placement View <br>
<br>
![17](https://user-images.githubusercontent.com/62461290/187059887-35c59d00-b959-4983-97f7-f229db63ca4b.png)<br>
<br>
![Screenshot 2022-08-28 112324](https://user-images.githubusercontent.com/62461290/187059896-3cd7613c-abdd-4838-81dc-0291a7a63241.png)<br>
<br>
<b>sky130_vsdinv</b> in the placement view :<br>
<br>
![18](https://user-images.githubusercontent.com/62461290/187059910-27dc9f35-9a5c-4518-8dc5-7c8238747b57.png)<br>
<br>
The sky130_vsdinv should also reflect in your netlist after placement <br>
<br>
![20](https://user-images.githubusercontent.com/62461290/187060017-d9e3eb1b-2cf6-4056-b7e8-4f9afd9daa5b.png)<br>

## Clock Tree Synthesis
```
% run_cts
```
![21](https://user-images.githubusercontent.com/62461290/187060069-447e33ad-952c-4303-92ac-cfbd45dd91b1.png)<br>

## Routing
```
% run_routing
```
![22](https://user-images.githubusercontent.com/62461290/187060096-ad41aab7-6435-45c8-a266-e6ebb955d691.png)<br>

### Routing Reports
Navigate to results->routing and type the Magic command in terminal to open the routing view <br>
```
$ magic -T /home/suyash/OpenLane/pdks/sky130A/libs.tech/magic/sky130A.tech read ../../tmp/merged.nom.lef def read iiitb_ptvm.def &
```
![23](https://user-images.githubusercontent.com/62461290/187060186-ec8a606b-9f79-4bb4-b0fe-5088fed426bb.png)<br>
<br>
Routing View<br>
<br>
![24](https://user-images.githubusercontent.com/62461290/187060219-d3194c75-d7b6-44c8-b760-19688209ca30.png)<br>
<br>
![25](https://user-images.githubusercontent.com/62461290/187060241-5e1341a4-0293-4957-aded-f30660d226e2.png)<br>
<br>
<b>sky130_vsdinv</b> in the routing view :<br>
<br>
![26](https://user-images.githubusercontent.com/62461290/187060280-5f093b87-366e-4355-a506-aa140022c78a.png)<br>
<br>
Area report by magic :<br>
<br>
![27](https://user-images.githubusercontent.com/62461290/187060331-cb12a7ce-963a-420e-9b38-12f137c11e9c.png)<br>
<br>
The sky130_vsdinv should also reflect in your netlist after routing <br>
<br>
![28](https://user-images.githubusercontent.com/62461290/187060367-db21b544-21b1-4447-9756-bc7aa947d23d.png)<br>

## Viewing Layout in KLayout

![klayou1](https://user-images.githubusercontent.com/62461290/187060556-280c7dc4-0f2f-4c0b-aac3-eec6d542ee06.png) <br>

![klayout2](https://user-images.githubusercontent.com/62461290/187060558-73bbc257-a068-4a11-9cf8-f91d2556b72f.png)<br>

![klayout3](https://user-images.githubusercontent.com/62461290/187060560-52d90a53-e509-4319-ae06-3781c246f384.png)<br>


### NOTE
We can also run the whole flow at once instead of step by step process by giving the following command in openlane container<br>
```
$ ./flow.tcl -design iiitb_ptvm
```
![100](https://user-images.githubusercontent.com/62461290/186196145-6850e928-d54a-404d-ad30-1fdb124a883b.png)<br>
<br>
All the steps will be automated and all the files will be generated.<br>

we can open the mag file and view the layout after the whole process by the following command, you can follow the path as per the image.<br>

```
$ magic -T /home/suyash/OpenLane/pdks/sky130A/libs.tech/magic/sky130A.tech iiitb_ptvm.mag &
```
<br>

![30](https://user-images.githubusercontent.com/62461290/186206184-3f146947-84d9-4178-9dd2-c54330067168.png)<br>
![31](https://user-images.githubusercontent.com/62461290/186206194-4ea81f2f-ab7f-4d34-840d-7aabff547774.png)<br>
![32](https://user-images.githubusercontent.com/62461290/186206196-526af125-b092-4bfc-9025-33dad27a3e6e.png)<br>


## Applications
Besides using the machine for dispensing tickets, the code can be modified to simulate other, similar FSMs.



## Contributors
- Suyash Misra
- Kunal Ghosh
- Nandini Dantu Devi
- Yash Kothari
- Tejas BN
- Aman Prajapati
- Pankaj

## Acknowledgments


- Kunal Ghosh, Director, VSD Corp. Pvt. Ltd.

## Contact Information

- Suyash Misra, Postgraduate Student, International Institute of Information Technology, Bangalore  suysh.msra@gmail.com
- Kunal Ghosh, Director, VSD Corp. Pvt. Ltd. kunalghosh@gmail.com
