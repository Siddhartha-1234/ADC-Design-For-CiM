v {xschem version=3.4.5 file_version=1.2
}
G {}
K {}
V {}
S {}
E {}
T {nand3_min: minimum-size NAND3 (PMOS 0.84/0.15 in parallel, NMOS 1.26/0.15 in series).  Y = 0 only when A = B = C = 1.} -400 -1000 0 0 0.3 0.3 {}
C {/home/ttuser/pdk/sky130A/libs.tech/xschem/sky130_fd_pr/pfet_01v8.sym} 100 -300 0 0 {name=MPA
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
N 120 -330 120 -350 {}
C {lab_pin.sym} 120 -350 0 0 {name=l1 sig_type=std_logic lab=VCC}
N 120 -270 120 -250 {}
C {lab_pin.sym} 120 -250 0 0 {name=l2 sig_type=std_logic lab=Y}
N 80 -300 60 -300 {}
C {lab_pin.sym} 60 -300 0 0 {name=l3 sig_type=std_logic lab=A}
N 120 -300 160 -300 {}
C {lab_pin.sym} 160 -300 0 1 {name=l4 sig_type=std_logic lab=VCC}
C {/home/ttuser/pdk/sky130A/libs.tech/xschem/sky130_fd_pr/pfet_01v8.sym} 400 -300 0 0 {name=MPB
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
N 420 -330 420 -350 {}
C {lab_pin.sym} 420 -350 0 0 {name=l5 sig_type=std_logic lab=VCC}
N 420 -270 420 -250 {}
C {lab_pin.sym} 420 -250 0 0 {name=l6 sig_type=std_logic lab=Y}
N 380 -300 360 -300 {}
C {lab_pin.sym} 360 -300 0 0 {name=l7 sig_type=std_logic lab=B}
N 420 -300 460 -300 {}
C {lab_pin.sym} 460 -300 0 1 {name=l8 sig_type=std_logic lab=VCC}
C {/home/ttuser/pdk/sky130A/libs.tech/xschem/sky130_fd_pr/pfet_01v8.sym} 700 -300 0 0 {name=MPC
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
N 720 -330 720 -350 {}
C {lab_pin.sym} 720 -350 0 0 {name=l9 sig_type=std_logic lab=VCC}
N 720 -270 720 -250 {}
C {lab_pin.sym} 720 -250 0 0 {name=l10 sig_type=std_logic lab=Y}
N 680 -300 660 -300 {}
C {lab_pin.sym} 660 -300 0 0 {name=l11 sig_type=std_logic lab=C}
N 720 -300 760 -300 {}
C {lab_pin.sym} 760 -300 0 1 {name=l12 sig_type=std_logic lab=VCC}
C {/home/ttuser/pdk/sky130A/libs.tech/xschem/sky130_fd_pr/nfet_01v8.sym} 400 -50 0 0 {name=MNA
L=0.15
W=1.26
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
N 420 -80 420 -100 {}
C {lab_pin.sym} 420 -100 0 0 {name=l13 sig_type=std_logic lab=Y}
N 420 -20 420 0 {}
C {lab_pin.sym} 420 0 0 0 {name=l14 sig_type=std_logic lab=N1}
N 380 -50 360 -50 {}
C {lab_pin.sym} 360 -50 0 0 {name=l15 sig_type=std_logic lab=A}
N 420 -50 460 -50 {}
C {lab_pin.sym} 460 -50 0 1 {name=l16 sig_type=std_logic lab=VSS}
C {/home/ttuser/pdk/sky130A/libs.tech/xschem/sky130_fd_pr/nfet_01v8.sym} 400 150 0 0 {name=MNB
L=0.15
W=1.26
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
N 420 120 420 100 {}
C {lab_pin.sym} 420 100 0 0 {name=l17 sig_type=std_logic lab=N1}
N 420 180 420 200 {}
C {lab_pin.sym} 420 200 0 0 {name=l18 sig_type=std_logic lab=N2}
N 380 150 360 150 {}
C {lab_pin.sym} 360 150 0 0 {name=l19 sig_type=std_logic lab=B}
N 420 150 460 150 {}
C {lab_pin.sym} 460 150 0 1 {name=l20 sig_type=std_logic lab=VSS}
C {/home/ttuser/pdk/sky130A/libs.tech/xschem/sky130_fd_pr/nfet_01v8.sym} 400 350 0 0 {name=MNC
L=0.15
W=1.26
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
N 420 320 420 300 {}
C {lab_pin.sym} 420 300 0 0 {name=l21 sig_type=std_logic lab=N2}
N 420 380 420 400 {}
C {lab_pin.sym} 420 400 0 0 {name=l22 sig_type=std_logic lab=VSS}
N 380 350 360 350 {}
C {lab_pin.sym} 360 350 0 0 {name=l23 sig_type=std_logic lab=C}
N 420 350 460 350 {}
C {lab_pin.sym} 460 350 0 1 {name=l24 sig_type=std_logic lab=VSS}
C {ipin.sym} -400 -700 0 0 {name=p1 lab=A}
C {ipin.sym} -400 -670 0 0 {name=p2 lab=B}
C {ipin.sym} -400 -640 0 0 {name=p3 lab=C}
C {ipin.sym} -400 -610 0 0 {name=p4 lab=VCC}
C {ipin.sym} -400 -580 0 0 {name=p5 lab=VSS}
C {opin.sym} -400 -550 0 0 {name=p6 lab=Y}
