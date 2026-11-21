v {xschem version=3.4.5 file_version=1.2
}
G {}
K {}
V {}
S {}
E {}
T {nand2_min: minimum-size NAND2 (PMOS 0.84/0.15 in parallel, NMOS 0.84/0.15 in series).  Same symbol and pins as nand2.sym.} -400 -1000 0 0 0.3 0.3 {}
C {/home/ttuser/pdk/sky130A/libs.tech/xschem/sky130_fd_pr/pfet_01v8.sym} 100 -250 0 0 {name=M1
L=0.15
W=0.84
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
N 120 -280 120 -300 {}
C {lab_pin.sym} 120 -300 0 0 {name=l1 sig_type=std_logic lab=VCC}
N 120 -220 120 -200 {}
C {lab_pin.sym} 120 -200 0 0 {name=l2 sig_type=std_logic lab=Y}
N 80 -250 60 -250 {}
C {lab_pin.sym} 60 -250 0 0 {name=l3 sig_type=std_logic lab=A}
N 120 -250 160 -250 {}
C {lab_pin.sym} 160 -250 0 1 {name=l4 sig_type=std_logic lab=VCC}
C {/home/ttuser/pdk/sky130A/libs.tech/xschem/sky130_fd_pr/pfet_01v8.sym} 400 -250 0 0 {name=M2
L=0.15
W=0.84
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
N 420 -280 420 -300 {}
C {lab_pin.sym} 420 -300 0 0 {name=l5 sig_type=std_logic lab=VCC}
N 420 -220 420 -200 {}
C {lab_pin.sym} 420 -200 0 0 {name=l6 sig_type=std_logic lab=Y}
N 380 -250 360 -250 {}
C {lab_pin.sym} 360 -250 0 0 {name=l7 sig_type=std_logic lab=B}
N 420 -250 460 -250 {}
C {lab_pin.sym} 460 -250 0 1 {name=l8 sig_type=std_logic lab=VCC}
C {/home/ttuser/pdk/sky130A/libs.tech/xschem/sky130_fd_pr/nfet_01v8.sym} 250 0 0 0 {name=M3
L=0.15
W=0.84
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
N 270 -30 270 -50 {}
C {lab_pin.sym} 270 -50 0 0 {name=l9 sig_type=std_logic lab=Y}
N 270 30 270 50 {}
C {lab_pin.sym} 270 50 0 0 {name=l10 sig_type=std_logic lab=N1}
N 230 0 210 0 {}
C {lab_pin.sym} 210 0 0 0 {name=l11 sig_type=std_logic lab=A}
N 270 0 310 0 {}
C {lab_pin.sym} 310 0 0 1 {name=l12 sig_type=std_logic lab=VSS}
C {/home/ttuser/pdk/sky130A/libs.tech/xschem/sky130_fd_pr/nfet_01v8.sym} 250 200 0 0 {name=M4
L=0.15
W=0.84
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
N 270 170 270 150 {}
C {lab_pin.sym} 270 150 0 0 {name=l13 sig_type=std_logic lab=N1}
N 270 230 270 250 {}
C {lab_pin.sym} 270 250 0 0 {name=l14 sig_type=std_logic lab=VSS}
N 230 200 210 200 {}
C {lab_pin.sym} 210 200 0 0 {name=l15 sig_type=std_logic lab=B}
N 270 200 310 200 {}
C {lab_pin.sym} 310 200 0 1 {name=l16 sig_type=std_logic lab=VSS}
C {ipin.sym} -400 -700 0 0 {name=p1 lab=A}
C {ipin.sym} -400 -670 0 0 {name=p2 lab=B}
C {opin.sym} -400 -640 0 0 {name=p3 lab=Y}
C {iopin.sym} -400 -610 0 0 {name=p4 lab=VCC}
C {iopin.sym} -400 -580 0 0 {name=p5 lab=VSS}
