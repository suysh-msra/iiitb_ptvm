# read design

read_verilog iiitb_ptvm.v

# generic synthesis
synth -top iiitb_ptvm
# mapping to mycells.lib
dfflibmap -liberty /usr/local/share/qflow/tech/osu018/osu018_stdcells.lib
abc -liberty /usr/local/share/qflow/tech/osu018/osu018_stdcells.lib
clean
flatten
# write synthesized design
write_verilog -assert synth_iiitb_ptvm.v
