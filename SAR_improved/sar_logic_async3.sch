v {xschem version=3.4.5 file_version=1.2
}
G {}
K {}
V {}
S {}
E {}
T {sar_logic_async3: self-timed SAR logic for the 3-bit Vcm-switching SAR.  Only SMP comes from outside.
Per bit k: two set-reset latches (dual rail):  Dk = 'decision was 1' (set when ACTk and YB low),  Nk = 'decision was 0' (set when ACTk and XB low).
Fk = Dk OR Nk = 'bit k is decided'.  Gk = 'bit k decided AND comparator has reset' (set when Fk = 1 and VALID = 0).
ACT2 = NOT SMP AND NOT F2,  ACT1 = G2 AND NOT F1,  ACT0 = G1 AND NOT F0.   CLK = ACT2 OR ACT1 OR ACT0.   EOC = F0.   SMP = 1 clears every latch.
Loop: CLK up -> comparator decides -> Dk or Nk sets (capacitor k moves at once) -> Fk = 1 -> ACTk = 0 -> CLK down -> comparator resets
-> VALID = 0 -> Gk sets -> ACT(k-1) = 1 -> CLK up for the next bit.  The reset half-loop (about 0.5 ns) is also the CDAC settling time:
simulated settling error at the next clock edge is under 2.5 mV (LSB = 100 mV) in tt, ss/125 C and ff/-40 C.
Capacitor drive straight from the latches: DNA = D2, UPA = N2, EA = F2, EAB = F2B (cap B: D1, N1, F1, F1B).} -400 -1000 0 0 0.3 0.3 {}
T {start: SMP falls -> bit 2 is active at once (ACT2 = NOR(SMP, F2)).     VALID = 1 while the comparator shows a decision.} 0 -520 0 0 0.4 0.4 {}
T {bit 2  (drives cap A, 2C)} 0 -200 0 0 0.45 0.45 {}
T {bit 1  (drives cap B, C)} 0 600 0 0 0.45 0.45 {}
T {bit 0  (last bit, no capacitor; F0 = EOC)} 0 1400 0 0 0.45 0.45 {}
T {comparator clock: CLK = ACT2 OR ACT1 OR ACT0  (at most one ACT is high at a time)} 2000 2150 0 0 0.4 0.4 {}
N 800 -420 820 -420 {}
N 800 -380 820 -380 {}
N 980 -400 1000 -400 {}
N 900 -480 900 -460 {}
N 900 -340 900 -320 {}
N 30 -20 50 -20 {}
N 30 20 50 20 {}
N 210 0 230 0 {}
N 130 -80 130 -60 {}
N 130 60 130 80 {}
N 380 0 400 0 {}
N 640 10 660 10 {}
N 490 -100 490 -80 {}
N 520 70 520 90 {}
N 800 -120 820 -120 {}
N 800 -80 820 -80 {}
N 980 -100 1000 -100 {}
N 900 -180 900 -160 {}
N 900 -40 900 -20 {}
N 800 130 820 130 {}
N 800 170 820 170 {}
N 980 150 1000 150 {}
N 900 70 900 90 {}
N 900 210 900 230 {}
N 1200 -220 1220 -220 {}
N 1200 -180 1220 -180 {}
N 1380 -200 1400 -200 {}
N 1300 -280 1300 -260 {}
N 1300 -140 1300 -120 {}
N 1200 -50 1220 -50 {}
N 1200 -10 1220 -10 {}
N 1380 -30 1400 -30 {}
N 1300 -110 1300 -90 {}
N 1300 30 1300 50 {}
N 1200 150 1220 150 {}
N 1200 190 1220 190 {}
N 1380 170 1400 170 {}
N 1300 90 1300 110 {}
N 1300 230 1300 250 {}
N 1200 320 1220 320 {}
N 1200 360 1220 360 {}
N 1380 340 1400 340 {}
N 1300 260 1300 280 {}
N 1300 400 1300 420 {}
N 1650 -20 1670 -20 {}
N 1650 20 1670 20 {}
N 1760 0 1780 0 {}
N 1680 -80 1680 -60 {}
N 1680 60 1680 80 {}
N 1930 0 1950 0 {}
N 2190 10 2210 10 {}
N 2040 -100 2040 -80 {}
N 2070 70 2070 90 {}
N 2350 -120 2370 -120 {}
N 2350 -80 2370 -80 {}
N 2530 -100 2550 -100 {}
N 2450 -180 2450 -160 {}
N 2450 -40 2450 -20 {}
N 2750 -220 2770 -220 {}
N 2750 -180 2770 -180 {}
N 2930 -200 2950 -200 {}
N 2850 -280 2850 -260 {}
N 2850 -140 2850 -120 {}
N 2750 -50 2770 -50 {}
N 2750 -10 2770 -10 {}
N 2930 -30 2950 -30 {}
N 2850 -110 2850 -90 {}
N 2850 30 2850 50 {}
N -110 800 -90 800 {}
N -110 840 -90 840 {}
N 70 820 90 820 {}
N -10 740 -10 760 {}
N -10 880 -10 900 {}
N 380 800 400 800 {}
N 640 810 660 810 {}
N 490 700 490 720 {}
N 520 870 520 890 {}
N 800 680 820 680 {}
N 800 720 820 720 {}
N 980 700 1000 700 {}
N 900 620 900 640 {}
N 900 760 900 780 {}
N 800 930 820 930 {}
N 800 970 820 970 {}
N 980 950 1000 950 {}
N 900 870 900 890 {}
N 900 1010 900 1030 {}
N 1200 580 1220 580 {}
N 1200 620 1220 620 {}
N 1380 600 1400 600 {}
N 1300 520 1300 540 {}
N 1300 660 1300 680 {}
N 1200 750 1220 750 {}
N 1200 790 1220 790 {}
N 1380 770 1400 770 {}
N 1300 690 1300 710 {}
N 1300 830 1300 850 {}
N 1200 950 1220 950 {}
N 1200 990 1220 990 {}
N 1380 970 1400 970 {}
N 1300 890 1300 910 {}
N 1300 1030 1300 1050 {}
N 1200 1120 1220 1120 {}
N 1200 1160 1220 1160 {}
N 1380 1140 1400 1140 {}
N 1300 1060 1300 1080 {}
N 1300 1200 1300 1220 {}
N 1650 780 1670 780 {}
N 1650 820 1670 820 {}
N 1830 800 1850 800 {}
N 1750 720 1750 740 {}
N 1750 860 1750 880 {}
N 2030 890 2050 890 {}
N 2290 900 2310 900 {}
N 2140 790 2140 810 {}
N 2170 960 2170 980 {}
N 2350 680 2370 680 {}
N 2350 720 2370 720 {}
N 2530 700 2550 700 {}
N 2450 620 2450 640 {}
N 2450 760 2450 780 {}
N 2750 580 2770 580 {}
N 2750 620 2770 620 {}
N 2930 600 2950 600 {}
N 2850 520 2850 540 {}
N 2850 660 2850 680 {}
N 2750 750 2770 750 {}
N 2750 790 2770 790 {}
N 2930 770 2950 770 {}
N 2850 690 2850 710 {}
N 2850 830 2850 850 {}
N -60 1600 -40 1600 {}
N -60 1640 -40 1640 {}
N 120 1620 140 1620 {}
N 40 1540 40 1560 {}
N 40 1680 40 1700 {}
N 380 1600 400 1600 {}
N 640 1610 660 1610 {}
N 490 1500 490 1520 {}
N 520 1670 520 1690 {}
N 800 1480 820 1480 {}
N 800 1520 820 1520 {}
N 980 1500 1000 1500 {}
N 900 1420 900 1440 {}
N 900 1560 900 1580 {}
N 800 1730 820 1730 {}
N 800 1770 820 1770 {}
N 980 1750 1000 1750 {}
N 900 1670 900 1690 {}
N 900 1810 900 1830 {}
N 1200 1380 1220 1380 {}
N 1200 1420 1220 1420 {}
N 1380 1400 1400 1400 {}
N 1300 1320 1300 1340 {}
N 1300 1460 1300 1480 {}
N 1200 1550 1220 1550 {}
N 1200 1590 1220 1590 {}
N 1380 1570 1400 1570 {}
N 1300 1490 1300 1510 {}
N 1300 1630 1300 1650 {}
N 1200 1750 1220 1750 {}
N 1200 1790 1220 1790 {}
N 1380 1770 1400 1770 {}
N 1300 1690 1300 1710 {}
N 1300 1830 1300 1850 {}
N 1200 1920 1220 1920 {}
N 1200 1960 1220 1960 {}
N 1380 1940 1400 1940 {}
N 1300 1860 1300 1880 {}
N 1300 2000 1300 2020 {}
N 1650 1580 1670 1580 {}
N 1650 1620 1670 1620 {}
N 1830 1600 1850 1600 {}
N 1750 1520 1750 1540 {}
N 1750 1660 1750 1680 {}
N 2090 1610 2110 1610 {}
N 2350 1620 2370 1620 {}
N 2200 1510 2200 1530 {}
N 2230 1680 2230 1700 {}
N 2410 2260 2430 2260 {}
N 2410 2280 2430 2280 {}
N 2410 2300 2430 2300 {}
N 2570 2260 2590 2260 {}
N 2410 2320 2430 2320 {}
N 2410 2340 2430 2340 {}
C {/home/ttuser/Documents/ADCAnalogDesign/SAR_improved/nand2_min.sym} 900 -400 0 0 {name=xval}
C {lab_pin.sym} 800 -420 0 0 {name=l1 sig_type=std_logic lab=XB}
C {lab_pin.sym} 800 -380 0 0 {name=l2 sig_type=std_logic lab=YB}
C {lab_pin.sym} 1000 -400 0 1 {name=l3 sig_type=std_logic lab=VALID}
C {lab_pin.sym} 900 -480 0 0 {name=l4 sig_type=std_logic lab=VCC}
C {lab_pin.sym} 900 -320 0 0 {name=l5 sig_type=std_logic lab=VSS}
C {/home/ttuser/Documents/ADCAnalogDesign/SAR_improved/nor2_min.sym} 130 0 0 0 {name=xa2}
C {lab_pin.sym} 30 -20 0 0 {name=l6 sig_type=std_logic lab=SMP}
C {lab_pin.sym} 30 20 0 0 {name=l7 sig_type=std_logic lab=F2}
C {lab_pin.sym} 230 0 0 1 {name=l8 sig_type=std_logic lab=ACT2}
C {lab_pin.sym} 130 -80 0 0 {name=l9 sig_type=std_logic lab=VCC}
C {lab_pin.sym} 130 80 0 0 {name=l10 sig_type=std_logic lab=VSS}
C {/home/ttuser/Documents/ADCAnalogDesign/SAR_improved/inv_min.sym} 550 20 0 0 {name=xab2}
C {lab_pin.sym} 380 0 0 0 {name=l11 sig_type=std_logic lab=ACT2}
C {lab_pin.sym} 660 10 0 1 {name=l12 sig_type=std_logic lab=ACT2B}
C {lab_pin.sym} 490 -100 0 0 {name=l13 sig_type=std_logic lab=VCC}
C {lab_pin.sym} 520 90 0 0 {name=l14 sig_type=std_logic lab=VSS}
C {/home/ttuser/Documents/ADCAnalogDesign/SAR_improved/nor2_min.sym} 900 -100 0 0 {name=xsp2}
C {lab_pin.sym} 800 -120 0 0 {name=l15 sig_type=std_logic lab=ACT2B}
C {lab_pin.sym} 800 -80 0 0 {name=l16 sig_type=std_logic lab=YB}
C {lab_pin.sym} 1000 -100 0 1 {name=l17 sig_type=std_logic lab=SP2}
C {lab_pin.sym} 900 -180 0 0 {name=l18 sig_type=std_logic lab=VCC}
C {lab_pin.sym} 900 -20 0 0 {name=l19 sig_type=std_logic lab=VSS}
C {/home/ttuser/Documents/ADCAnalogDesign/SAR_improved/nor2_min.sym} 900 150 0 0 {name=xsn2}
C {lab_pin.sym} 800 130 0 0 {name=l20 sig_type=std_logic lab=ACT2B}
C {lab_pin.sym} 800 170 0 0 {name=l21 sig_type=std_logic lab=XB}
C {lab_pin.sym} 1000 150 0 1 {name=l22 sig_type=std_logic lab=SN2}
C {lab_pin.sym} 900 70 0 0 {name=l23 sig_type=std_logic lab=VCC}
C {lab_pin.sym} 900 230 0 0 {name=l24 sig_type=std_logic lab=VSS}
C {/home/ttuser/Documents/ADCAnalogDesign/SAR_improved/nor2_min.sym} 1300 -200 0 0 {name=xd2}
C {lab_pin.sym} 1200 -220 0 0 {name=l25 sig_type=std_logic lab=SMP}
C {lab_pin.sym} 1200 -180 0 0 {name=l26 sig_type=std_logic lab=D2B}
C {lab_pin.sym} 1400 -200 0 1 {name=l27 sig_type=std_logic lab=D2}
C {lab_pin.sym} 1300 -280 0 0 {name=l28 sig_type=std_logic lab=VCC}
C {lab_pin.sym} 1300 -120 0 0 {name=l29 sig_type=std_logic lab=VSS}
C {/home/ttuser/Documents/ADCAnalogDesign/SAR_improved/nor2_min.sym} 1300 -30 0 0 {name=xdb2}
C {lab_pin.sym} 1200 -50 0 0 {name=l30 sig_type=std_logic lab=SP2}
C {lab_pin.sym} 1200 -10 0 0 {name=l31 sig_type=std_logic lab=D2}
C {lab_pin.sym} 1400 -30 0 1 {name=l32 sig_type=std_logic lab=D2B}
C {lab_pin.sym} 1300 -110 0 0 {name=l33 sig_type=std_logic lab=VCC}
C {lab_pin.sym} 1300 50 0 0 {name=l34 sig_type=std_logic lab=VSS}
C {/home/ttuser/Documents/ADCAnalogDesign/SAR_improved/nor2_min.sym} 1300 170 0 0 {name=xn2}
C {lab_pin.sym} 1200 150 0 0 {name=l35 sig_type=std_logic lab=SMP}
C {lab_pin.sym} 1200 190 0 0 {name=l36 sig_type=std_logic lab=N2B}
C {lab_pin.sym} 1400 170 0 1 {name=l37 sig_type=std_logic lab=N2}
C {lab_pin.sym} 1300 90 0 0 {name=l38 sig_type=std_logic lab=VCC}
C {lab_pin.sym} 1300 250 0 0 {name=l39 sig_type=std_logic lab=VSS}
C {/home/ttuser/Documents/ADCAnalogDesign/SAR_improved/nor2_min.sym} 1300 340 0 0 {name=xnb2}
C {lab_pin.sym} 1200 320 0 0 {name=l40 sig_type=std_logic lab=SN2}
C {lab_pin.sym} 1200 360 0 0 {name=l41 sig_type=std_logic lab=N2}
C {lab_pin.sym} 1400 340 0 1 {name=l42 sig_type=std_logic lab=N2B}
C {lab_pin.sym} 1300 260 0 0 {name=l43 sig_type=std_logic lab=VCC}
C {lab_pin.sym} 1300 420 0 0 {name=l44 sig_type=std_logic lab=VSS}
C {/home/ttuser/Documents/ADCAnalogDesign/SAR_improved/nor2_min.sym} 1680 0 0 0 {name=xf2}
C {lab_pin.sym} 1650 -20 0 0 {name=l45 sig_type=std_logic lab=D2}
C {lab_pin.sym} 1650 20 0 0 {name=l46 sig_type=std_logic lab=N2}
C {lab_pin.sym} 1780 0 0 1 {name=l47 sig_type=std_logic lab=F2B}
C {lab_pin.sym} 1680 -80 0 0 {name=l48 sig_type=std_logic lab=VCC}
C {lab_pin.sym} 1680 80 0 0 {name=l49 sig_type=std_logic lab=VSS}
C {/home/ttuser/Documents/ADCAnalogDesign/SAR_improved/inv_min.sym} 2100 20 0 0 {name=xfi2}
C {lab_pin.sym} 1930 0 0 0 {name=l50 sig_type=std_logic lab=F2B}
C {lab_pin.sym} 2210 10 0 1 {name=l51 sig_type=std_logic lab=F2}
C {lab_pin.sym} 2040 -100 0 0 {name=l52 sig_type=std_logic lab=VCC}
C {lab_pin.sym} 2070 90 0 0 {name=l53 sig_type=std_logic lab=VSS}
C {/home/ttuser/Documents/ADCAnalogDesign/SAR_improved/nor2_min.sym} 2450 -100 0 0 {name=xsg2}
C {lab_pin.sym} 2350 -120 0 0 {name=l54 sig_type=std_logic lab=F2B}
C {lab_pin.sym} 2350 -80 0 0 {name=l55 sig_type=std_logic lab=VALID}
C {lab_pin.sym} 2550 -100 0 1 {name=l56 sig_type=std_logic lab=SG2}
C {lab_pin.sym} 2450 -180 0 0 {name=l57 sig_type=std_logic lab=VCC}
C {lab_pin.sym} 2450 -20 0 0 {name=l58 sig_type=std_logic lab=VSS}
C {/home/ttuser/Documents/ADCAnalogDesign/SAR_improved/nor2_min.sym} 2850 -200 0 0 {name=xg2}
C {lab_pin.sym} 2750 -220 0 0 {name=l59 sig_type=std_logic lab=SMP}
C {lab_pin.sym} 2750 -180 0 0 {name=l60 sig_type=std_logic lab=G2B}
C {lab_pin.sym} 2950 -200 0 1 {name=l61 sig_type=std_logic lab=G2}
C {lab_pin.sym} 2850 -280 0 0 {name=l62 sig_type=std_logic lab=VCC}
C {lab_pin.sym} 2850 -120 0 0 {name=l63 sig_type=std_logic lab=VSS}
C {/home/ttuser/Documents/ADCAnalogDesign/SAR_improved/nor2_min.sym} 2850 -30 0 0 {name=xgb2}
C {lab_pin.sym} 2750 -50 0 0 {name=l64 sig_type=std_logic lab=SG2}
C {lab_pin.sym} 2750 -10 0 0 {name=l65 sig_type=std_logic lab=G2}
C {lab_pin.sym} 2950 -30 0 1 {name=l66 sig_type=std_logic lab=G2B}
C {lab_pin.sym} 2850 -110 0 0 {name=l67 sig_type=std_logic lab=VCC}
C {lab_pin.sym} 2850 50 0 0 {name=l68 sig_type=std_logic lab=VSS}
C {/home/ttuser/Documents/ADCAnalogDesign/SAR_improved/nor2_min.sym} -10 820 0 0 {name=xa1}
C {lab_pin.sym} -110 800 0 0 {name=l69 sig_type=std_logic lab=G2B}
C {lab_pin.sym} -110 840 0 0 {name=l70 sig_type=std_logic lab=F1}
C {lab_pin.sym} 90 820 0 1 {name=l71 sig_type=std_logic lab=ACT1}
C {lab_pin.sym} -10 740 0 0 {name=l72 sig_type=std_logic lab=VCC}
C {lab_pin.sym} -10 900 0 0 {name=l73 sig_type=std_logic lab=VSS}
C {/home/ttuser/Documents/ADCAnalogDesign/SAR_improved/inv_min.sym} 550 820 0 0 {name=xab1}
C {lab_pin.sym} 380 800 0 0 {name=l74 sig_type=std_logic lab=ACT1}
C {lab_pin.sym} 660 810 0 1 {name=l75 sig_type=std_logic lab=ACT1B}
C {lab_pin.sym} 490 700 0 0 {name=l76 sig_type=std_logic lab=VCC}
C {lab_pin.sym} 520 890 0 0 {name=l77 sig_type=std_logic lab=VSS}
C {/home/ttuser/Documents/ADCAnalogDesign/SAR_improved/nor2_min.sym} 900 700 0 0 {name=xsp1}
C {lab_pin.sym} 800 680 0 0 {name=l78 sig_type=std_logic lab=ACT1B}
C {lab_pin.sym} 800 720 0 0 {name=l79 sig_type=std_logic lab=YB}
C {lab_pin.sym} 1000 700 0 1 {name=l80 sig_type=std_logic lab=SP1}
C {lab_pin.sym} 900 620 0 0 {name=l81 sig_type=std_logic lab=VCC}
C {lab_pin.sym} 900 780 0 0 {name=l82 sig_type=std_logic lab=VSS}
C {/home/ttuser/Documents/ADCAnalogDesign/SAR_improved/nor2_min.sym} 900 950 0 0 {name=xsn1}
C {lab_pin.sym} 800 930 0 0 {name=l83 sig_type=std_logic lab=ACT1B}
C {lab_pin.sym} 800 970 0 0 {name=l84 sig_type=std_logic lab=XB}
C {lab_pin.sym} 1000 950 0 1 {name=l85 sig_type=std_logic lab=SN1}
C {lab_pin.sym} 900 870 0 0 {name=l86 sig_type=std_logic lab=VCC}
C {lab_pin.sym} 900 1030 0 0 {name=l87 sig_type=std_logic lab=VSS}
C {/home/ttuser/Documents/ADCAnalogDesign/SAR_improved/nor2_min.sym} 1300 600 0 0 {name=xd1}
C {lab_pin.sym} 1200 580 0 0 {name=l88 sig_type=std_logic lab=SMP}
C {lab_pin.sym} 1200 620 0 0 {name=l89 sig_type=std_logic lab=D1B}
C {lab_pin.sym} 1400 600 0 1 {name=l90 sig_type=std_logic lab=D1}
C {lab_pin.sym} 1300 520 0 0 {name=l91 sig_type=std_logic lab=VCC}
C {lab_pin.sym} 1300 680 0 0 {name=l92 sig_type=std_logic lab=VSS}
C {/home/ttuser/Documents/ADCAnalogDesign/SAR_improved/nor2_min.sym} 1300 770 0 0 {name=xdb1}
C {lab_pin.sym} 1200 750 0 0 {name=l93 sig_type=std_logic lab=SP1}
C {lab_pin.sym} 1200 790 0 0 {name=l94 sig_type=std_logic lab=D1}
C {lab_pin.sym} 1400 770 0 1 {name=l95 sig_type=std_logic lab=D1B}
C {lab_pin.sym} 1300 690 0 0 {name=l96 sig_type=std_logic lab=VCC}
C {lab_pin.sym} 1300 850 0 0 {name=l97 sig_type=std_logic lab=VSS}
C {/home/ttuser/Documents/ADCAnalogDesign/SAR_improved/nor2_min.sym} 1300 970 0 0 {name=xn1}
C {lab_pin.sym} 1200 950 0 0 {name=l98 sig_type=std_logic lab=SMP}
C {lab_pin.sym} 1200 990 0 0 {name=l99 sig_type=std_logic lab=N1B}
C {lab_pin.sym} 1400 970 0 1 {name=l100 sig_type=std_logic lab=N1}
C {lab_pin.sym} 1300 890 0 0 {name=l101 sig_type=std_logic lab=VCC}
C {lab_pin.sym} 1300 1050 0 0 {name=l102 sig_type=std_logic lab=VSS}
C {/home/ttuser/Documents/ADCAnalogDesign/SAR_improved/nor2_min.sym} 1300 1140 0 0 {name=xnb1}
C {lab_pin.sym} 1200 1120 0 0 {name=l103 sig_type=std_logic lab=SN1}
C {lab_pin.sym} 1200 1160 0 0 {name=l104 sig_type=std_logic lab=N1}
C {lab_pin.sym} 1400 1140 0 1 {name=l105 sig_type=std_logic lab=N1B}
C {lab_pin.sym} 1300 1060 0 0 {name=l106 sig_type=std_logic lab=VCC}
C {lab_pin.sym} 1300 1220 0 0 {name=l107 sig_type=std_logic lab=VSS}
C {/home/ttuser/Documents/ADCAnalogDesign/SAR_improved/nor2_min.sym} 1750 800 0 0 {name=xf1}
C {lab_pin.sym} 1650 780 0 0 {name=l108 sig_type=std_logic lab=D1}
C {lab_pin.sym} 1650 820 0 0 {name=l109 sig_type=std_logic lab=N1}
C {lab_pin.sym} 1850 800 0 1 {name=l110 sig_type=std_logic lab=F1B}
C {lab_pin.sym} 1750 720 0 0 {name=l111 sig_type=std_logic lab=VCC}
C {lab_pin.sym} 1750 880 0 0 {name=l112 sig_type=std_logic lab=VSS}
C {/home/ttuser/Documents/ADCAnalogDesign/SAR_improved/inv_min.sym} 2200 910 0 0 {name=xfi1}
C {lab_pin.sym} 2030 890 0 0 {name=l113 sig_type=std_logic lab=F1B}
C {lab_pin.sym} 2310 900 0 1 {name=l114 sig_type=std_logic lab=F1}
C {lab_pin.sym} 2140 790 0 0 {name=l115 sig_type=std_logic lab=VCC}
C {lab_pin.sym} 2170 980 0 0 {name=l116 sig_type=std_logic lab=VSS}
C {/home/ttuser/Documents/ADCAnalogDesign/SAR_improved/nor2_min.sym} 2450 700 0 0 {name=xsg1}
C {lab_pin.sym} 2350 680 0 0 {name=l117 sig_type=std_logic lab=F1B}
C {lab_pin.sym} 2350 720 0 0 {name=l118 sig_type=std_logic lab=VALID}
C {lab_pin.sym} 2550 700 0 1 {name=l119 sig_type=std_logic lab=SG1}
C {lab_pin.sym} 2450 620 0 0 {name=l120 sig_type=std_logic lab=VCC}
C {lab_pin.sym} 2450 780 0 0 {name=l121 sig_type=std_logic lab=VSS}
C {/home/ttuser/Documents/ADCAnalogDesign/SAR_improved/nor2_min.sym} 2850 600 0 0 {name=xg1}
C {lab_pin.sym} 2750 580 0 0 {name=l122 sig_type=std_logic lab=SMP}
C {lab_pin.sym} 2750 620 0 0 {name=l123 sig_type=std_logic lab=G1B}
C {lab_pin.sym} 2950 600 0 1 {name=l124 sig_type=std_logic lab=G1}
C {lab_pin.sym} 2850 520 0 0 {name=l125 sig_type=std_logic lab=VCC}
C {lab_pin.sym} 2850 680 0 0 {name=l126 sig_type=std_logic lab=VSS}
C {/home/ttuser/Documents/ADCAnalogDesign/SAR_improved/nor2_min.sym} 2850 770 0 0 {name=xgb1}
C {lab_pin.sym} 2750 750 0 0 {name=l127 sig_type=std_logic lab=SG1}
C {lab_pin.sym} 2750 790 0 0 {name=l128 sig_type=std_logic lab=G1}
C {lab_pin.sym} 2950 770 0 1 {name=l129 sig_type=std_logic lab=G1B}
C {lab_pin.sym} 2850 690 0 0 {name=l130 sig_type=std_logic lab=VCC}
C {lab_pin.sym} 2850 850 0 0 {name=l131 sig_type=std_logic lab=VSS}
C {/home/ttuser/Documents/ADCAnalogDesign/SAR_improved/nor2_min.sym} 40 1620 0 0 {name=xa0}
C {lab_pin.sym} -60 1600 0 0 {name=l132 sig_type=std_logic lab=G1B}
C {lab_pin.sym} -60 1640 0 0 {name=l133 sig_type=std_logic lab=EOC}
C {lab_pin.sym} 140 1620 0 1 {name=l134 sig_type=std_logic lab=ACT0}
C {lab_pin.sym} 40 1540 0 0 {name=l135 sig_type=std_logic lab=VCC}
C {lab_pin.sym} 40 1700 0 0 {name=l136 sig_type=std_logic lab=VSS}
C {/home/ttuser/Documents/ADCAnalogDesign/SAR_improved/inv_min.sym} 550 1620 0 0 {name=xab0}
C {lab_pin.sym} 380 1600 0 0 {name=l137 sig_type=std_logic lab=ACT0}
C {lab_pin.sym} 660 1610 0 1 {name=l138 sig_type=std_logic lab=ACT0B}
C {lab_pin.sym} 490 1500 0 0 {name=l139 sig_type=std_logic lab=VCC}
C {lab_pin.sym} 520 1690 0 0 {name=l140 sig_type=std_logic lab=VSS}
C {/home/ttuser/Documents/ADCAnalogDesign/SAR_improved/nor2_min.sym} 900 1500 0 0 {name=xsp0}
C {lab_pin.sym} 800 1480 0 0 {name=l141 sig_type=std_logic lab=ACT0B}
C {lab_pin.sym} 800 1520 0 0 {name=l142 sig_type=std_logic lab=YB}
C {lab_pin.sym} 1000 1500 0 1 {name=l143 sig_type=std_logic lab=SP0}
C {lab_pin.sym} 900 1420 0 0 {name=l144 sig_type=std_logic lab=VCC}
C {lab_pin.sym} 900 1580 0 0 {name=l145 sig_type=std_logic lab=VSS}
C {/home/ttuser/Documents/ADCAnalogDesign/SAR_improved/nor2_min.sym} 900 1750 0 0 {name=xsn0}
C {lab_pin.sym} 800 1730 0 0 {name=l146 sig_type=std_logic lab=ACT0B}
C {lab_pin.sym} 800 1770 0 0 {name=l147 sig_type=std_logic lab=XB}
C {lab_pin.sym} 1000 1750 0 1 {name=l148 sig_type=std_logic lab=SN0}
C {lab_pin.sym} 900 1670 0 0 {name=l149 sig_type=std_logic lab=VCC}
C {lab_pin.sym} 900 1830 0 0 {name=l150 sig_type=std_logic lab=VSS}
C {/home/ttuser/Documents/ADCAnalogDesign/SAR_improved/nor2_min.sym} 1300 1400 0 0 {name=xd0}
C {lab_pin.sym} 1200 1380 0 0 {name=l151 sig_type=std_logic lab=SMP}
C {lab_pin.sym} 1200 1420 0 0 {name=l152 sig_type=std_logic lab=D0B}
C {lab_pin.sym} 1400 1400 0 1 {name=l153 sig_type=std_logic lab=D0}
C {lab_pin.sym} 1300 1320 0 0 {name=l154 sig_type=std_logic lab=VCC}
C {lab_pin.sym} 1300 1480 0 0 {name=l155 sig_type=std_logic lab=VSS}
C {/home/ttuser/Documents/ADCAnalogDesign/SAR_improved/nor2_min.sym} 1300 1570 0 0 {name=xdb0}
C {lab_pin.sym} 1200 1550 0 0 {name=l156 sig_type=std_logic lab=SP0}
C {lab_pin.sym} 1200 1590 0 0 {name=l157 sig_type=std_logic lab=D0}
C {lab_pin.sym} 1400 1570 0 1 {name=l158 sig_type=std_logic lab=D0B}
C {lab_pin.sym} 1300 1490 0 0 {name=l159 sig_type=std_logic lab=VCC}
C {lab_pin.sym} 1300 1650 0 0 {name=l160 sig_type=std_logic lab=VSS}
C {/home/ttuser/Documents/ADCAnalogDesign/SAR_improved/nor2_min.sym} 1300 1770 0 0 {name=xn0}
C {lab_pin.sym} 1200 1750 0 0 {name=l161 sig_type=std_logic lab=SMP}
C {lab_pin.sym} 1200 1790 0 0 {name=l162 sig_type=std_logic lab=N0B}
C {lab_pin.sym} 1400 1770 0 1 {name=l163 sig_type=std_logic lab=N0}
C {lab_pin.sym} 1300 1690 0 0 {name=l164 sig_type=std_logic lab=VCC}
C {lab_pin.sym} 1300 1850 0 0 {name=l165 sig_type=std_logic lab=VSS}
C {/home/ttuser/Documents/ADCAnalogDesign/SAR_improved/nor2_min.sym} 1300 1940 0 0 {name=xnb0}
C {lab_pin.sym} 1200 1920 0 0 {name=l166 sig_type=std_logic lab=SN0}
C {lab_pin.sym} 1200 1960 0 0 {name=l167 sig_type=std_logic lab=N0}
C {lab_pin.sym} 1400 1940 0 1 {name=l168 sig_type=std_logic lab=N0B}
C {lab_pin.sym} 1300 1860 0 0 {name=l169 sig_type=std_logic lab=VCC}
C {lab_pin.sym} 1300 2020 0 0 {name=l170 sig_type=std_logic lab=VSS}
C {/home/ttuser/Documents/ADCAnalogDesign/SAR_improved/nor2_min.sym} 1750 1600 0 0 {name=xf0}
C {lab_pin.sym} 1650 1580 0 0 {name=l171 sig_type=std_logic lab=D0}
C {lab_pin.sym} 1650 1620 0 0 {name=l172 sig_type=std_logic lab=N0}
C {lab_pin.sym} 1850 1600 0 1 {name=l173 sig_type=std_logic lab=F0B}
C {lab_pin.sym} 1750 1520 0 0 {name=l174 sig_type=std_logic lab=VCC}
C {lab_pin.sym} 1750 1680 0 0 {name=l175 sig_type=std_logic lab=VSS}
C {/home/ttuser/Documents/ADCAnalogDesign/SAR_improved/inv_min.sym} 2260 1630 0 0 {name=xfi0}
C {lab_pin.sym} 2090 1610 0 0 {name=l176 sig_type=std_logic lab=F0B}
C {lab_pin.sym} 2370 1620 0 1 {name=l177 sig_type=std_logic lab=EOC}
C {lab_pin.sym} 2200 1510 0 0 {name=l178 sig_type=std_logic lab=VCC}
C {lab_pin.sym} 2230 1700 0 0 {name=l179 sig_type=std_logic lab=VSS}
C {/home/ttuser/Documents/ADCAnalogDesign/SAR_improved/nand3_min.sym} 2500 2300 0 0 {name=xclk}
C {lab_pin.sym} 2410 2260 0 0 {name=l180 sig_type=std_logic lab=ACT2B}
C {lab_pin.sym} 2410 2280 0 0 {name=l181 sig_type=std_logic lab=ACT1B}
C {lab_pin.sym} 2410 2300 0 0 {name=l182 sig_type=std_logic lab=ACT0B}
C {lab_pin.sym} 2590 2260 0 1 {name=l183 sig_type=std_logic lab=CLK}
C {lab_pin.sym} 2410 2320 0 0 {name=l184 sig_type=std_logic lab=VCC}
C {lab_pin.sym} 2410 2340 0 0 {name=l185 sig_type=std_logic lab=VSS}
C {ipin.sym} -400 -700 0 0 {name=p1 lab=VCC}
C {ipin.sym} -400 -670 0 0 {name=p2 lab=VSS}
C {ipin.sym} -400 -640 0 0 {name=p3 lab=SMP}
C {ipin.sym} -400 -610 0 0 {name=p4 lab=XB}
C {ipin.sym} -400 -580 0 0 {name=p5 lab=YB}
C {opin.sym} -400 -550 0 0 {name=p6 lab=CLK}
C {opin.sym} -400 -520 0 0 {name=p7 lab=EOC}
C {opin.sym} -400 -490 0 0 {name=p8 lab=D2}
C {opin.sym} -400 -460 0 0 {name=p9 lab=D1}
C {opin.sym} -400 -430 0 0 {name=p10 lab=D0}
C {opin.sym} -400 -400 0 0 {name=p11 lab=N2}
C {opin.sym} -400 -370 0 0 {name=p12 lab=F2}
C {opin.sym} -400 -340 0 0 {name=p13 lab=F2B}
C {opin.sym} -400 -310 0 0 {name=p14 lab=N1}
C {opin.sym} -400 -280 0 0 {name=p15 lab=F1}
C {opin.sym} -400 -250 0 0 {name=p16 lab=F1B}
