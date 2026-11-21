v {xschem version=3.4.5 file_version=1.2
}
G {}
K {}
V {}
S {}
E {}
T {latch_comp_async: the same PMOS-input StrongARM latch as latch_comp, without the NAND SR latch at the output.
CLK = 0: reset, X = Y = 0, so XB = YB = 1.   CLK = 1: evaluate, ONE of X, Y goes to VDD.
YB falls  <=>  INP > INN (VX > VR, bit = 1).     XB falls  <=>  INP < INN (VX < VR, bit = 0).
In the self-timed SAR, 'one of XB, YB is low' means 'the decision is finished' (VALID = NAND(XB, YB)),
and the SAR logic latches the bit itself, so the comparator's own SR latch is no longer needed.} -400 -1000 0 0 0.3 0.3 {}
C {/home/ttuser/Documents/ADCAnalogDesign/inverter.sym} -600 -200 0 0 {name=x5}
N -750 -220 -770 -220 {}
C {lab_pin.sym} -770 -220 0 0 {name=l1 sig_type=std_logic lab=CLK}
N -510 -210 -490 -210 {}
C {lab_pin.sym} -490 -210 0 1 {name=l2 sig_type=std_logic lab=CLKB}
N -660 -300 -660 -320 {}
C {lab_pin.sym} -660 -320 0 0 {name=l3 sig_type=std_logic lab=VDD}
N -630 -150 -630 -130 {}
C {lab_pin.sym} -630 -130 0 0 {name=l4 sig_type=std_logic lab=VSS}
C {/home/ttuser/pdk/sky130A/libs.tech/xschem/sky130_fd_pr/pfet_01v8.sym} 300 -600 0 0 {name=M7
L=0.15
W=2
nf=1
mult=1
ad="'int((nf+1)/2) * W/nf * 0.29'" 
pd="'2*int((nf+1)/2) * (W/nf + 0.29)'"
as="'int((nf+2)/2) * W/nf * 0.29'" 
ps="'2*int((nf+2)/2) * (W/nf + 0.29)'"
nrd="'0.29 / W'" nrs="'0.29 / W'"
sa=0 sb=0 sd=0
model=pfet_01v8
spiceprefix=X
}
N 320 -630 320 -650 {}
C {lab_pin.sym} 320 -650 0 0 {name=l5 sig_type=std_logic lab=VDD}
N 320 -570 320 -550 {}
C {lab_pin.sym} 320 -550 0 0 {name=l6 sig_type=std_logic lab=TAIL}
N 280 -600 260 -600 {}
C {lab_pin.sym} 260 -600 0 0 {name=l7 sig_type=std_logic lab=CLKB}
N 320 -600 360 -600 {}
C {lab_pin.sym} 360 -600 0 1 {name=l8 sig_type=std_logic lab=VDD}
C {/home/ttuser/pdk/sky130A/libs.tech/xschem/sky130_fd_pr/pfet_01v8.sym} 100 -400 0 0 {name=M1
L=0.5
W=2
nf=1
mult=1
ad="'int((nf+1)/2) * W/nf * 0.29'" 
pd="'2*int((nf+1)/2) * (W/nf + 0.29)'"
as="'int((nf+2)/2) * W/nf * 0.29'" 
ps="'2*int((nf+2)/2) * (W/nf + 0.29)'"
nrd="'0.29 / W'" nrs="'0.29 / W'"
sa=0 sb=0 sd=0
model=pfet_01v8
spiceprefix=X
}
N 120 -430 120 -450 {}
C {lab_pin.sym} 120 -450 0 0 {name=l9 sig_type=std_logic lab=TAIL}
N 120 -370 120 -350 {}
C {lab_pin.sym} 120 -350 0 0 {name=l10 sig_type=std_logic lab=P}
N 80 -400 60 -400 {}
C {lab_pin.sym} 60 -400 0 0 {name=l11 sig_type=std_logic lab=INP}
N 120 -400 160 -400 {}
C {lab_pin.sym} 160 -400 0 1 {name=l12 sig_type=std_logic lab=VDD}
C {/home/ttuser/pdk/sky130A/libs.tech/xschem/sky130_fd_pr/pfet_01v8.sym} 500 -400 0 0 {name=M2
L=0.5
W=2
nf=1
mult=1
ad="'int((nf+1)/2) * W/nf * 0.29'" 
pd="'2*int((nf+1)/2) * (W/nf + 0.29)'"
as="'int((nf+2)/2) * W/nf * 0.29'" 
ps="'2*int((nf+2)/2) * (W/nf + 0.29)'"
nrd="'0.29 / W'" nrs="'0.29 / W'"
sa=0 sb=0 sd=0
model=pfet_01v8
spiceprefix=X
}
N 520 -430 520 -450 {}
C {lab_pin.sym} 520 -450 0 0 {name=l13 sig_type=std_logic lab=TAIL}
N 520 -370 520 -350 {}
C {lab_pin.sym} 520 -350 0 0 {name=l14 sig_type=std_logic lab=Q}
N 480 -400 460 -400 {}
C {lab_pin.sym} 460 -400 0 0 {name=l15 sig_type=std_logic lab=INN}
N 520 -400 560 -400 {}
C {lab_pin.sym} 560 -400 0 1 {name=l16 sig_type=std_logic lab=VDD}
C {/home/ttuser/pdk/sky130A/libs.tech/xschem/sky130_fd_pr/pfet_01v8.sym} 100 -200 0 0 {name=M3
L=0.15
W=1
nf=1
mult=1
ad="'int((nf+1)/2) * W/nf * 0.29'" 
pd="'2*int((nf+1)/2) * (W/nf + 0.29)'"
as="'int((nf+2)/2) * W/nf * 0.29'" 
ps="'2*int((nf+2)/2) * (W/nf + 0.29)'"
nrd="'0.29 / W'" nrs="'0.29 / W'"
sa=0 sb=0 sd=0
model=pfet_01v8
spiceprefix=X
}
N 120 -230 120 -250 {}
C {lab_pin.sym} 120 -250 0 0 {name=l17 sig_type=std_logic lab=P}
N 120 -170 120 -150 {}
C {lab_pin.sym} 120 -150 0 0 {name=l18 sig_type=std_logic lab=X}
N 80 -200 60 -200 {}
C {lab_pin.sym} 60 -200 0 0 {name=l19 sig_type=std_logic lab=Y}
N 120 -200 160 -200 {}
C {lab_pin.sym} 160 -200 0 1 {name=l20 sig_type=std_logic lab=VDD}
C {/home/ttuser/pdk/sky130A/libs.tech/xschem/sky130_fd_pr/pfet_01v8.sym} 500 -200 0 0 {name=M4
L=0.15
W=1
nf=1
mult=1
ad="'int((nf+1)/2) * W/nf * 0.29'" 
pd="'2*int((nf+1)/2) * (W/nf + 0.29)'"
as="'int((nf+2)/2) * W/nf * 0.29'" 
ps="'2*int((nf+2)/2) * (W/nf + 0.29)'"
nrd="'0.29 / W'" nrs="'0.29 / W'"
sa=0 sb=0 sd=0
model=pfet_01v8
spiceprefix=X
}
N 520 -230 520 -250 {}
C {lab_pin.sym} 520 -250 0 0 {name=l21 sig_type=std_logic lab=Q}
N 520 -170 520 -150 {}
C {lab_pin.sym} 520 -150 0 0 {name=l22 sig_type=std_logic lab=Y}
N 480 -200 460 -200 {}
C {lab_pin.sym} 460 -200 0 0 {name=l23 sig_type=std_logic lab=X}
N 520 -200 560 -200 {}
C {lab_pin.sym} 560 -200 0 1 {name=l24 sig_type=std_logic lab=VDD}
C {/home/ttuser/pdk/sky130A/libs.tech/xschem/sky130_fd_pr/nfet_01v8.sym} 100 0 0 0 {name=M5
L=0.15
W=0.5
nf=1
mult=1
ad="'int((nf+1)/2) * W/nf * 0.29'" 
pd="'2*int((nf+1)/2) * (W/nf + 0.29)'"
as="'int((nf+2)/2) * W/nf * 0.29'" 
ps="'2*int((nf+2)/2) * (W/nf + 0.29)'"
nrd="'0.29 / W'" nrs="'0.29 / W'"
sa=0 sb=0 sd=0
model=nfet_01v8
spiceprefix=X
}
N 120 -30 120 -50 {}
C {lab_pin.sym} 120 -50 0 0 {name=l25 sig_type=std_logic lab=X}
N 120 30 120 50 {}
C {lab_pin.sym} 120 50 0 0 {name=l26 sig_type=std_logic lab=VSS}
N 80 0 60 0 {}
C {lab_pin.sym} 60 0 0 0 {name=l27 sig_type=std_logic lab=Y}
N 120 0 160 0 {}
C {lab_pin.sym} 160 0 0 1 {name=l28 sig_type=std_logic lab=VSS}
C {/home/ttuser/pdk/sky130A/libs.tech/xschem/sky130_fd_pr/nfet_01v8.sym} 500 0 0 0 {name=M6
L=0.15
W=0.5
nf=1
mult=1
ad="'int((nf+1)/2) * W/nf * 0.29'" 
pd="'2*int((nf+1)/2) * (W/nf + 0.29)'"
as="'int((nf+2)/2) * W/nf * 0.29'" 
ps="'2*int((nf+2)/2) * (W/nf + 0.29)'"
nrd="'0.29 / W'" nrs="'0.29 / W'"
sa=0 sb=0 sd=0
model=nfet_01v8
spiceprefix=X
}
N 520 -30 520 -50 {}
C {lab_pin.sym} 520 -50 0 0 {name=l29 sig_type=std_logic lab=Y}
N 520 30 520 50 {}
C {lab_pin.sym} 520 50 0 0 {name=l30 sig_type=std_logic lab=VSS}
N 480 0 460 0 {}
C {lab_pin.sym} 460 0 0 0 {name=l31 sig_type=std_logic lab=X}
N 520 0 560 0 {}
C {lab_pin.sym} 560 0 0 1 {name=l32 sig_type=std_logic lab=VSS}
C {/home/ttuser/pdk/sky130A/libs.tech/xschem/sky130_fd_pr/nfet_01v8.sym} 900 -300 0 0 {name=MR1
L=0.15
W=0.5
nf=1
mult=1
ad="'int((nf+1)/2) * W/nf * 0.29'" 
pd="'2*int((nf+1)/2) * (W/nf + 0.29)'"
as="'int((nf+2)/2) * W/nf * 0.29'" 
ps="'2*int((nf+2)/2) * (W/nf + 0.29)'"
nrd="'0.29 / W'" nrs="'0.29 / W'"
sa=0 sb=0 sd=0
model=nfet_01v8
spiceprefix=X
}
N 920 -330 920 -350 {}
C {lab_pin.sym} 920 -350 0 0 {name=l33 sig_type=std_logic lab=P}
N 920 -270 920 -250 {}
C {lab_pin.sym} 920 -250 0 0 {name=l34 sig_type=std_logic lab=VSS}
N 880 -300 860 -300 {}
C {lab_pin.sym} 860 -300 0 0 {name=l35 sig_type=std_logic lab=CLKB}
N 920 -300 960 -300 {}
C {lab_pin.sym} 960 -300 0 1 {name=l36 sig_type=std_logic lab=VSS}
C {/home/ttuser/pdk/sky130A/libs.tech/xschem/sky130_fd_pr/nfet_01v8.sym} 1120 -300 0 0 {name=MR2
L=0.15
W=0.5
nf=1
mult=1
ad="'int((nf+1)/2) * W/nf * 0.29'" 
pd="'2*int((nf+1)/2) * (W/nf + 0.29)'"
as="'int((nf+2)/2) * W/nf * 0.29'" 
ps="'2*int((nf+2)/2) * (W/nf + 0.29)'"
nrd="'0.29 / W'" nrs="'0.29 / W'"
sa=0 sb=0 sd=0
model=nfet_01v8
spiceprefix=X
}
N 1140 -330 1140 -350 {}
C {lab_pin.sym} 1140 -350 0 0 {name=l37 sig_type=std_logic lab=Q}
N 1140 -270 1140 -250 {}
C {lab_pin.sym} 1140 -250 0 0 {name=l38 sig_type=std_logic lab=VSS}
N 1100 -300 1080 -300 {}
C {lab_pin.sym} 1080 -300 0 0 {name=l39 sig_type=std_logic lab=CLKB}
N 1140 -300 1180 -300 {}
C {lab_pin.sym} 1180 -300 0 1 {name=l40 sig_type=std_logic lab=VSS}
C {/home/ttuser/pdk/sky130A/libs.tech/xschem/sky130_fd_pr/nfet_01v8.sym} 1340 -300 0 0 {name=MR3
L=0.15
W=0.5
nf=1
mult=1
ad="'int((nf+1)/2) * W/nf * 0.29'" 
pd="'2*int((nf+1)/2) * (W/nf + 0.29)'"
as="'int((nf+2)/2) * W/nf * 0.29'" 
ps="'2*int((nf+2)/2) * (W/nf + 0.29)'"
nrd="'0.29 / W'" nrs="'0.29 / W'"
sa=0 sb=0 sd=0
model=nfet_01v8
spiceprefix=X
}
N 1360 -330 1360 -350 {}
C {lab_pin.sym} 1360 -350 0 0 {name=l41 sig_type=std_logic lab=X}
N 1360 -270 1360 -250 {}
C {lab_pin.sym} 1360 -250 0 0 {name=l42 sig_type=std_logic lab=VSS}
N 1320 -300 1300 -300 {}
C {lab_pin.sym} 1300 -300 0 0 {name=l43 sig_type=std_logic lab=CLKB}
N 1360 -300 1400 -300 {}
C {lab_pin.sym} 1400 -300 0 1 {name=l44 sig_type=std_logic lab=VSS}
C {/home/ttuser/pdk/sky130A/libs.tech/xschem/sky130_fd_pr/nfet_01v8.sym} 1560 -300 0 0 {name=MR4
L=0.15
W=0.5
nf=1
mult=1
ad="'int((nf+1)/2) * W/nf * 0.29'" 
pd="'2*int((nf+1)/2) * (W/nf + 0.29)'"
as="'int((nf+2)/2) * W/nf * 0.29'" 
ps="'2*int((nf+2)/2) * (W/nf + 0.29)'"
nrd="'0.29 / W'" nrs="'0.29 / W'"
sa=0 sb=0 sd=0
model=nfet_01v8
spiceprefix=X
}
N 1580 -330 1580 -350 {}
C {lab_pin.sym} 1580 -350 0 0 {name=l45 sig_type=std_logic lab=Y}
N 1580 -270 1580 -250 {}
C {lab_pin.sym} 1580 -250 0 0 {name=l46 sig_type=std_logic lab=VSS}
N 1540 -300 1520 -300 {}
C {lab_pin.sym} 1520 -300 0 0 {name=l47 sig_type=std_logic lab=CLKB}
N 1580 -300 1620 -300 {}
C {lab_pin.sym} 1620 -300 0 1 {name=l48 sig_type=std_logic lab=VSS}
C {/home/ttuser/Documents/ADCAnalogDesign/inverter.sym} 1000 250 0 0 {name=x3}
N 850 230 830 230 {}
C {lab_pin.sym} 830 230 0 0 {name=l49 sig_type=std_logic lab=X}
N 1090 240 1110 240 {}
C {lab_pin.sym} 1110 240 0 1 {name=l50 sig_type=std_logic lab=XB}
N 940 150 940 130 {}
C {lab_pin.sym} 940 130 0 0 {name=l51 sig_type=std_logic lab=VDD}
N 970 300 970 320 {}
C {lab_pin.sym} 970 320 0 0 {name=l52 sig_type=std_logic lab=VSS}
C {/home/ttuser/Documents/ADCAnalogDesign/inverter.sym} 1000 550 0 0 {name=x4}
N 850 530 830 530 {}
C {lab_pin.sym} 830 530 0 0 {name=l53 sig_type=std_logic lab=Y}
N 1090 540 1110 540 {}
C {lab_pin.sym} 1110 540 0 1 {name=l54 sig_type=std_logic lab=YB}
N 940 450 940 430 {}
C {lab_pin.sym} 940 430 0 0 {name=l55 sig_type=std_logic lab=VDD}
N 970 600 970 620 {}
C {lab_pin.sym} 970 620 0 0 {name=l56 sig_type=std_logic lab=VSS}
C {ipin.sym} -400 -700 0 0 {name=p1 lab=VDD}
C {ipin.sym} -400 -670 0 0 {name=p2 lab=VSS}
C {ipin.sym} -400 -640 0 0 {name=p3 lab=CLK}
C {ipin.sym} -400 -610 0 0 {name=p4 lab=INP}
C {ipin.sym} -400 -580 0 0 {name=p5 lab=INN}
C {opin.sym} -400 -550 0 0 {name=p6 lab=XB}
C {opin.sym} -400 -520 0 0 {name=p7 lab=YB}
