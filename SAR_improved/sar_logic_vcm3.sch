v {xschem version=3.4.5 file_version=1.2
}
G {}
K {}
V {}
S {}
E {}
T {sar_logic_vcm3: SAR logic for Vcm-based switching, built from minimum-size inverters and NOR2 gates (inv_min, nor2_min).
Ck (k = 2, 1, 0) marks the comparator decision for bit k (the comparator clock CLK pulses at the same time).
Bit latch (NOR SR):  Sk = Ck.COM,  Rk = Ck.COMB  ->  Dk = comparator decision taken during Ck (held afterwards).
Update flag (NOR SR): Uk sets Ek = 1, SMP clears it.  Switch controls:  UPk = NOR(EkB, Dk) = Ek.(not Dk) (bottom plate to VREF when Dk = 0),
DNk = NOR(EkB, DkB) = Ek.Dk (bottom plate to 0 when Dk = 1), and while Ek = 0 the plate stays at VCM.  D2 drives cap A (2C), D1 drives cap B (C).} -400 -1000 0 0 0.3 0.3 {}
T {bit 2  (drives cap A)} -100 -150 0 0 0.4 0.4 {}
T {bit 1  (drives cap B)} -100 550 0 0 0.4 0.4 {}
T {bit 0  (no capacitor: last decision)} -100 1250 0 0 0.4 0.4 {}
N 30 -20 50 -20 {
lab=C2}
N 290 -10 310 -10 {
lab=C2B}
N 140 -120 140 -100 {
lab=VCC}
N 170 50 170 70 {
lab=VSS}
N 500 -120 520 -120 {
lab=C2B}
N 500 -80 520 -80 {
lab=COMB}
N 680 -100 700 -100 {
lab=S2}
N 600 -180 600 -160 {
lab=VCC}
N 600 -40 600 -20 {
lab=VSS}
N 500 100 520 100 {
lab=C2B}
N 500 140 520 140 {
lab=COM}
N 680 120 700 120 {
lab=R2}
N 600 40 600 60 {
lab=VCC}
N 600 180 600 200 {
lab=VSS}
N 900 -120 920 -120 {
lab=R2}
N 830 -80 920 -80 {
lab=D2B}
N 1080 -100 1100 -100 {
lab=D2}
N 1000 -180 1000 -160 {
lab=VCC}
N 1000 -40 1000 -20 {
lab=VSS}
N 900 100 920 100 {
lab=S2}
N 770 140 920 140 {
lab=D2}
N 1080 120 1100 120 {
lab=D2B}
N 1000 40 1000 60 {
lab=VCC}
N 1000 180 1000 200 {
lab=VSS}
N 1350 -120 1370 -120 {
lab=SMP}
N 1180 -80 1370 -80 {
lab=EAB}
N 1530 -100 1680 -100 {
lab=EA}
N 1450 -180 1450 -160 {
lab=VCC}
N 1450 -40 1450 -20 {
lab=VSS}
N 1350 100 1370 100 {
lab=U2}
N 1220 140 1370 140 {
lab=EA}
N 1530 120 1670 120 {
lab=EAB}
N 1450 40 1450 60 {
lab=VCC}
N 1450 180 1450 200 {
lab=VSS}
N 1800 -120 1820 -120 {
lab=EAB}
N 1800 -80 1820 -80 {
lab=D2}
N 1980 -100 2000 -100 {
lab=UPA}
N 1900 -180 1900 -160 {
lab=VCC}
N 1900 -40 1900 -20 {
lab=VSS}
N 1800 100 1820 100 {
lab=EAB}
N 1800 140 1820 140 {
lab=D2B}
N 1980 120 2000 120 {
lab=DNA}
N 1900 40 1900 60 {
lab=VCC}
N 1900 180 1900 200 {
lab=VSS}
N 30 680 50 680 {
lab=C1}
N 290 690 310 690 {
lab=C1B}
N 140 580 140 600 {
lab=VCC}
N 170 750 170 770 {
lab=VSS}
N 500 580 520 580 {
lab=C1B}
N 500 620 520 620 {
lab=COMB}
N 680 600 700 600 {
lab=S1}
N 600 520 600 540 {
lab=VCC}
N 600 660 600 680 {
lab=VSS}
N 500 800 520 800 {
lab=C1B}
N 500 840 520 840 {
lab=COM}
N 680 820 700 820 {
lab=R1}
N 600 740 600 760 {
lab=VCC}
N 600 880 600 900 {
lab=VSS}
N 900 580 920 580 {
lab=R1}
N 900 620 920 620 {
lab=D1B}
N 1080 600 1100 600 {
lab=D1}
N 1000 520 1000 540 {
lab=VCC}
N 1000 660 1000 680 {
lab=VSS}
N 900 800 920 800 {
lab=S1}
N 900 840 920 840 {
lab=D1}
N 1080 820 1100 820 {
lab=D1B}
N 1000 740 1000 760 {
lab=VCC}
N 1000 880 1000 900 {
lab=VSS}
N 1350 580 1370 580 {
lab=SMP}
N 1350 620 1370 620 {
lab=EBB}
N 1530 600 1550 600 {
lab=EB}
N 1450 520 1450 540 {
lab=VCC}
N 1450 660 1450 680 {
lab=VSS}
N 1350 800 1370 800 {
lab=U1}
N 1350 840 1370 840 {
lab=EB}
N 1530 820 1550 820 {
lab=EBB}
N 1450 740 1450 760 {
lab=VCC}
N 1450 880 1450 900 {
lab=VSS}
N 1800 580 1820 580 {
lab=EBB}
N 1800 620 1820 620 {
lab=D1}
N 1980 600 2000 600 {
lab=UPB}
N 1900 520 1900 540 {
lab=VCC}
N 1900 660 1900 680 {
lab=VSS}
N 1800 800 1820 800 {
lab=EBB}
N 1800 840 1820 840 {
lab=D1B}
N 1980 820 2000 820 {
lab=DNB}
N 1900 740 1900 760 {
lab=VCC}
N 1900 880 1900 900 {
lab=VSS}
N 30 1380 50 1380 {
lab=C0}
N 290 1390 310 1390 {
lab=C0B}
N 140 1280 140 1300 {
lab=VCC}
N 170 1450 170 1470 {
lab=VSS}
N 500 1280 520 1280 {
lab=C0B}
N 500 1320 520 1320 {
lab=COMB}
N 680 1300 700 1300 {
lab=S0}
N 600 1220 600 1240 {
lab=VCC}
N 600 1360 600 1380 {
lab=VSS}
N 500 1500 520 1500 {
lab=C0B}
N 500 1540 520 1540 {
lab=COM}
N 680 1520 700 1520 {
lab=R0}
N 600 1440 600 1460 {
lab=VCC}
N 600 1580 600 1600 {
lab=VSS}
N 900 1280 920 1280 {
lab=R0}
N 900 1320 920 1320 {
lab=D0B}
N 1080 1300 1100 1300 {
lab=D0}
N 1000 1220 1000 1240 {
lab=VCC}
N 1000 1360 1000 1380 {
lab=VSS}
N 900 1500 920 1500 {
lab=S0}
N 900 1540 920 1540 {
lab=D0}
N 1080 1520 1100 1520 {
lab=D0B}
N 1000 1440 1000 1460 {
lab=VCC}
N 1000 1580 1000 1600 {
lab=VSS}
N 390 -120 500 -120 {
lab=C2B}
N 390 -120 390 100 {
lab=C2B}
N 390 100 500 100 {
lab=C2B}
N 700 -100 900 100 {
lab=S2}
N 700 120 790 -110 {
lab=R2}
N 790 -110 900 -120 {
lab=R2}
N 1270 -80 1270 -40 {
lab=EAB}
N 1270 -40 1560 40 {
lab=EAB}
N 1560 40 1560 120 {
lab=EAB}
N 1270 80 1270 140 {
lab=EA}
N 1270 80 1620 -40 {
lab=EA}
N 1620 -100 1620 -40 {
lab=EA}
N 860 -80 860 -20 {
lab=D2B}
N 860 -20 1090 50 {
lab=D2B}
N 1090 50 1100 60 {
lab=D2B}
N 1100 60 1100 120 {
lab=D2B}
N 840 80 840 140 {
lab=D2}
N 840 80 1100 -40 {
lab=D2}
N 1100 -100 1100 -40 {
lab=D2}
N 1740 -120 1800 -120 {
lab=EAB}
N 1740 -120 1740 100 {
lab=EAB}
N 1740 100 1800 100 {
lab=EAB}
C {/home/ttuser/Documents/ADCAnalogDesign/SAR_improved/inv_min.sym} 200 0 0 0 {name=xi2}
C {lab_pin.sym} 30 -20 0 0 {name=l1 sig_type=std_logic lab=C2}
C {lab_pin.sym} 310 -10 0 1 {name=l2 sig_type=std_logic lab=C2B}
C {lab_pin.sym} 140 -120 0 0 {name=l3 sig_type=std_logic lab=VCC}
C {lab_pin.sym} 170 70 0 0 {name=l4 sig_type=std_logic lab=VSS}
C {/home/ttuser/Documents/ADCAnalogDesign/SAR_improved/nor2_min.sym} 600 -100 0 0 {name=xs2}
C {lab_pin.sym} 390 -120 0 0 {name=l5 sig_type=std_logic lab=C2B}
C {lab_pin.sym} 500 -80 0 0 {name=l6 sig_type=std_logic lab=COMB}
C {lab_pin.sym} 700 -100 0 1 {name=l7 sig_type=std_logic lab=S2}
C {lab_pin.sym} 600 -180 0 0 {name=l8 sig_type=std_logic lab=VCC}
C {lab_pin.sym} 600 -20 0 0 {name=l9 sig_type=std_logic lab=VSS}
C {/home/ttuser/Documents/ADCAnalogDesign/SAR_improved/nor2_min.sym} 600 120 0 0 {name=xr2}
C {lab_pin.sym} 500 140 0 0 {name=l11 sig_type=std_logic lab=COM}
C {lab_pin.sym} 700 120 0 1 {name=l12 sig_type=std_logic lab=R2}
C {lab_pin.sym} 600 40 0 0 {name=l13 sig_type=std_logic lab=VCC}
C {lab_pin.sym} 600 200 0 0 {name=l14 sig_type=std_logic lab=VSS}
C {/home/ttuser/Documents/ADCAnalogDesign/SAR_improved/nor2_min.sym} 1000 -100 0 0 {name=xd2}
C {lab_pin.sym} 830 -80 0 0 {name=l16 sig_type=std_logic lab=D2B}
C {lab_pin.sym} 1000 -180 0 0 {name=l18 sig_type=std_logic lab=VCC}
C {lab_pin.sym} 1000 -20 0 0 {name=l19 sig_type=std_logic lab=VSS}
C {/home/ttuser/Documents/ADCAnalogDesign/SAR_improved/nor2_min.sym} 1000 120 0 0 {name=xdb2}
C {lab_pin.sym} 770 140 0 0 {name=l21 sig_type=std_logic lab=D2}
C {lab_pin.sym} 1000 40 0 0 {name=l23 sig_type=std_logic lab=VCC}
C {lab_pin.sym} 1000 200 0 0 {name=l24 sig_type=std_logic lab=VSS}
C {/home/ttuser/Documents/ADCAnalogDesign/SAR_improved/nor2_min.sym} 1450 -100 0 0 {name=xe2}
C {lab_pin.sym} 1350 -120 0 0 {name=l25 sig_type=std_logic lab=SMP}
C {lab_pin.sym} 1180 -80 0 0 {name=l26 sig_type=std_logic lab=EAB}
C {lab_pin.sym} 1450 -180 0 0 {name=l28 sig_type=std_logic lab=VCC}
C {lab_pin.sym} 1450 -20 0 0 {name=l29 sig_type=std_logic lab=VSS}
C {/home/ttuser/Documents/ADCAnalogDesign/SAR_improved/nor2_min.sym} 1450 120 0 0 {name=xeb2}
C {lab_pin.sym} 1350 100 0 0 {name=l30 sig_type=std_logic lab=U2}
C {lab_pin.sym} 1220 140 0 0 {name=l31 sig_type=std_logic lab=EA}
C {lab_pin.sym} 1450 40 0 0 {name=l33 sig_type=std_logic lab=VCC}
C {lab_pin.sym} 1450 200 0 0 {name=l34 sig_type=std_logic lab=VSS}
C {/home/ttuser/Documents/ADCAnalogDesign/SAR_improved/nor2_min.sym} 1900 -100 0 0 {name=xu2}
C {lab_pin.sym} 1740 -120 0 0 {name=l35 sig_type=std_logic lab=EAB}
C {lab_pin.sym} 1800 -80 0 0 {name=l36 sig_type=std_logic lab=D2}
C {lab_pin.sym} 2000 -100 0 1 {name=l37 sig_type=std_logic lab=UPA}
C {lab_pin.sym} 1900 -180 0 0 {name=l38 sig_type=std_logic lab=VCC}
C {lab_pin.sym} 1900 -20 0 0 {name=l39 sig_type=std_logic lab=VSS}
C {/home/ttuser/Documents/ADCAnalogDesign/SAR_improved/nor2_min.sym} 1900 120 0 0 {name=xn2}
C {lab_pin.sym} 1800 140 0 0 {name=l41 sig_type=std_logic lab=D2B}
C {lab_pin.sym} 2000 120 0 1 {name=l42 sig_type=std_logic lab=DNA}
C {lab_pin.sym} 1900 40 0 0 {name=l43 sig_type=std_logic lab=VCC}
C {lab_pin.sym} 1900 200 0 0 {name=l44 sig_type=std_logic lab=VSS}
C {/home/ttuser/Documents/ADCAnalogDesign/SAR_improved/inv_min.sym} 200 700 0 0 {name=xi1}
C {lab_pin.sym} 30 680 0 0 {name=l45 sig_type=std_logic lab=C1}
C {lab_pin.sym} 310 690 0 1 {name=l46 sig_type=std_logic lab=C1B}
C {lab_pin.sym} 140 580 0 0 {name=l47 sig_type=std_logic lab=VCC}
C {lab_pin.sym} 170 770 0 0 {name=l48 sig_type=std_logic lab=VSS}
C {/home/ttuser/Documents/ADCAnalogDesign/SAR_improved/nor2_min.sym} 600 600 0 0 {name=xs1}
C {lab_pin.sym} 500 580 0 0 {name=l49 sig_type=std_logic lab=C1B}
C {lab_pin.sym} 500 620 0 0 {name=l50 sig_type=std_logic lab=COMB}
C {lab_pin.sym} 700 600 0 1 {name=l51 sig_type=std_logic lab=S1}
C {lab_pin.sym} 600 520 0 0 {name=l52 sig_type=std_logic lab=VCC}
C {lab_pin.sym} 600 680 0 0 {name=l53 sig_type=std_logic lab=VSS}
C {/home/ttuser/Documents/ADCAnalogDesign/SAR_improved/nor2_min.sym} 600 820 0 0 {name=xr1}
C {lab_pin.sym} 500 800 0 0 {name=l54 sig_type=std_logic lab=C1B}
C {lab_pin.sym} 500 840 0 0 {name=l55 sig_type=std_logic lab=COM}
C {lab_pin.sym} 700 820 0 1 {name=l56 sig_type=std_logic lab=R1}
C {lab_pin.sym} 600 740 0 0 {name=l57 sig_type=std_logic lab=VCC}
C {lab_pin.sym} 600 900 0 0 {name=l58 sig_type=std_logic lab=VSS}
C {/home/ttuser/Documents/ADCAnalogDesign/SAR_improved/nor2_min.sym} 1000 600 0 0 {name=xd1}
C {lab_pin.sym} 900 580 0 0 {name=l59 sig_type=std_logic lab=R1}
C {lab_pin.sym} 900 620 0 0 {name=l60 sig_type=std_logic lab=D1B}
C {lab_pin.sym} 1100 600 0 1 {name=l61 sig_type=std_logic lab=D1}
C {lab_pin.sym} 1000 520 0 0 {name=l62 sig_type=std_logic lab=VCC}
C {lab_pin.sym} 1000 680 0 0 {name=l63 sig_type=std_logic lab=VSS}
C {/home/ttuser/Documents/ADCAnalogDesign/SAR_improved/nor2_min.sym} 1000 820 0 0 {name=xdb1}
C {lab_pin.sym} 900 800 0 0 {name=l64 sig_type=std_logic lab=S1}
C {lab_pin.sym} 900 840 0 0 {name=l65 sig_type=std_logic lab=D1}
C {lab_pin.sym} 1100 820 0 1 {name=l66 sig_type=std_logic lab=D1B}
C {lab_pin.sym} 1000 740 0 0 {name=l67 sig_type=std_logic lab=VCC}
C {lab_pin.sym} 1000 900 0 0 {name=l68 sig_type=std_logic lab=VSS}
C {/home/ttuser/Documents/ADCAnalogDesign/SAR_improved/nor2_min.sym} 1450 600 0 0 {name=xe1}
C {lab_pin.sym} 1350 580 0 0 {name=l69 sig_type=std_logic lab=SMP}
C {lab_pin.sym} 1350 620 0 0 {name=l70 sig_type=std_logic lab=EBB}
C {lab_pin.sym} 1550 600 0 1 {name=l71 sig_type=std_logic lab=EB}
C {lab_pin.sym} 1450 520 0 0 {name=l72 sig_type=std_logic lab=VCC}
C {lab_pin.sym} 1450 680 0 0 {name=l73 sig_type=std_logic lab=VSS}
C {/home/ttuser/Documents/ADCAnalogDesign/SAR_improved/nor2_min.sym} 1450 820 0 0 {name=xeb1}
C {lab_pin.sym} 1350 800 0 0 {name=l74 sig_type=std_logic lab=U1}
C {lab_pin.sym} 1350 840 0 0 {name=l75 sig_type=std_logic lab=EB}
C {lab_pin.sym} 1550 820 0 1 {name=l76 sig_type=std_logic lab=EBB}
C {lab_pin.sym} 1450 740 0 0 {name=l77 sig_type=std_logic lab=VCC}
C {lab_pin.sym} 1450 900 0 0 {name=l78 sig_type=std_logic lab=VSS}
C {/home/ttuser/Documents/ADCAnalogDesign/SAR_improved/nor2_min.sym} 1900 600 0 0 {name=xu1}
C {lab_pin.sym} 1800 580 0 0 {name=l79 sig_type=std_logic lab=EBB}
C {lab_pin.sym} 1800 620 0 0 {name=l80 sig_type=std_logic lab=D1}
C {lab_pin.sym} 2000 600 0 1 {name=l81 sig_type=std_logic lab=UPB}
C {lab_pin.sym} 1900 520 0 0 {name=l82 sig_type=std_logic lab=VCC}
C {lab_pin.sym} 1900 680 0 0 {name=l83 sig_type=std_logic lab=VSS}
C {/home/ttuser/Documents/ADCAnalogDesign/SAR_improved/nor2_min.sym} 1900 820 0 0 {name=xn1}
C {lab_pin.sym} 1800 800 0 0 {name=l84 sig_type=std_logic lab=EBB}
C {lab_pin.sym} 1800 840 0 0 {name=l85 sig_type=std_logic lab=D1B}
C {lab_pin.sym} 2000 820 0 1 {name=l86 sig_type=std_logic lab=DNB}
C {lab_pin.sym} 1900 740 0 0 {name=l87 sig_type=std_logic lab=VCC}
C {lab_pin.sym} 1900 900 0 0 {name=l88 sig_type=std_logic lab=VSS}
C {/home/ttuser/Documents/ADCAnalogDesign/SAR_improved/inv_min.sym} 200 1400 0 0 {name=xi0}
C {lab_pin.sym} 30 1380 0 0 {name=l89 sig_type=std_logic lab=C0}
C {lab_pin.sym} 310 1390 0 1 {name=l90 sig_type=std_logic lab=C0B}
C {lab_pin.sym} 140 1280 0 0 {name=l91 sig_type=std_logic lab=VCC}
C {lab_pin.sym} 170 1470 0 0 {name=l92 sig_type=std_logic lab=VSS}
C {/home/ttuser/Documents/ADCAnalogDesign/SAR_improved/nor2_min.sym} 600 1300 0 0 {name=xs0}
C {lab_pin.sym} 500 1280 0 0 {name=l93 sig_type=std_logic lab=C0B}
C {lab_pin.sym} 500 1320 0 0 {name=l94 sig_type=std_logic lab=COMB}
C {lab_pin.sym} 700 1300 0 1 {name=l95 sig_type=std_logic lab=S0}
C {lab_pin.sym} 600 1220 0 0 {name=l96 sig_type=std_logic lab=VCC}
C {lab_pin.sym} 600 1380 0 0 {name=l97 sig_type=std_logic lab=VSS}
C {/home/ttuser/Documents/ADCAnalogDesign/SAR_improved/nor2_min.sym} 600 1520 0 0 {name=xr0}
C {lab_pin.sym} 500 1500 0 0 {name=l98 sig_type=std_logic lab=C0B}
C {lab_pin.sym} 500 1540 0 0 {name=l99 sig_type=std_logic lab=COM}
C {lab_pin.sym} 700 1520 0 1 {name=l100 sig_type=std_logic lab=R0}
C {lab_pin.sym} 600 1440 0 0 {name=l101 sig_type=std_logic lab=VCC}
C {lab_pin.sym} 600 1600 0 0 {name=l102 sig_type=std_logic lab=VSS}
C {/home/ttuser/Documents/ADCAnalogDesign/SAR_improved/nor2_min.sym} 1000 1300 0 0 {name=xd0}
C {lab_pin.sym} 900 1280 0 0 {name=l103 sig_type=std_logic lab=R0}
C {lab_pin.sym} 900 1320 0 0 {name=l104 sig_type=std_logic lab=D0B}
C {lab_pin.sym} 1100 1300 0 1 {name=l105 sig_type=std_logic lab=D0}
C {lab_pin.sym} 1000 1220 0 0 {name=l106 sig_type=std_logic lab=VCC}
C {lab_pin.sym} 1000 1380 0 0 {name=l107 sig_type=std_logic lab=VSS}
C {/home/ttuser/Documents/ADCAnalogDesign/SAR_improved/nor2_min.sym} 1000 1520 0 0 {name=xdb0}
C {lab_pin.sym} 900 1500 0 0 {name=l108 sig_type=std_logic lab=S0}
C {lab_pin.sym} 900 1540 0 0 {name=l109 sig_type=std_logic lab=D0}
C {lab_pin.sym} 1100 1520 0 1 {name=l110 sig_type=std_logic lab=D0B}
C {lab_pin.sym} 1000 1440 0 0 {name=l111 sig_type=std_logic lab=VCC}
C {lab_pin.sym} 1000 1600 0 0 {name=l112 sig_type=std_logic lab=VSS}
C {ipin.sym} -400 -700 0 0 {name=p1 lab=VCC}
C {ipin.sym} -400 -670 0 0 {name=p2 lab=VSS}
C {ipin.sym} -400 -640 0 0 {name=p3 lab=SMP}
C {ipin.sym} -400 -610 0 0 {name=p4 lab=C2}
C {ipin.sym} -400 -580 0 0 {name=p5 lab=C1}
C {ipin.sym} -400 -550 0 0 {name=p6 lab=C0}
C {ipin.sym} -400 -520 0 0 {name=p7 lab=U2}
C {ipin.sym} -400 -490 0 0 {name=p8 lab=U1}
C {ipin.sym} -400 -460 0 0 {name=p9 lab=COM}
C {ipin.sym} -400 -430 0 0 {name=p10 lab=COMB}
C {opin.sym} -400 -400 0 0 {name=p11 lab=D2}
C {opin.sym} -400 -370 0 0 {name=p12 lab=D1}
C {opin.sym} -400 -340 0 0 {name=p13 lab=D0}
C {opin.sym} -400 -310 0 0 {name=p14 lab=UPA}
C {opin.sym} -400 -280 0 0 {name=p15 lab=DNA}
C {opin.sym} -400 -250 0 0 {name=p16 lab=EA}
C {opin.sym} -400 -220 0 0 {name=p17 lab=EAB}
C {opin.sym} -400 -190 0 0 {name=p18 lab=UPB}
C {opin.sym} -400 -160 0 0 {name=p19 lab=DNB}
C {opin.sym} -400 -130 0 0 {name=p20 lab=EB}
C {opin.sym} -400 -100 0 0 {name=p21 lab=EBB}
