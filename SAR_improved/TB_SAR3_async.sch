v {xschem version=3.4.5 file_version=1.2
}
G {}
K {}
V {}
S {}
E {}
T {TB_SAR3_async: asynchronous 3-bit SAR.  The ONLY timing source is SMP: 4 ns high (sample), then the ADC converts by itself.
10 ns per conversion.  VIN = 0.05 ... 0.75 V -> expected codes 0 ... 7.  EOC rises when the code is ready (about 4 ns after SMP falls).
Compare with TB_SAR3_v3: there, 7 sources (SMP, CLK, C2, U2, C1, U1, C0) set the timing; here 1.} -400 -1000 0 0 0.3 0.3 {}
C {/home/ttuser/Documents/ADCAnalogDesign/SAR_improved/sar_adc3_async.sym} 500 -350 0 0 {name=x1}
N 400 -400 380 -400 {}
C {lab_pin.sym} 380 -400 0 0 {name=l1 sig_type=std_logic lab=VCC}
N 400 -360 380 -360 {}
C {lab_pin.sym} 380 -360 0 0 {name=l2 sig_type=std_logic lab=VREF}
N 400 -340 380 -340 {}
C {lab_pin.sym} 380 -340 0 0 {name=l3 sig_type=std_logic lab=VCM}
N 400 -320 380 -320 {}
C {lab_pin.sym} 380 -320 0 0 {name=l4 sig_type=std_logic lab=VIN}
N 400 -300 380 -300 {}
C {lab_pin.sym} 380 -300 0 0 {name=l5 sig_type=std_logic lab=SMP}
N 600 -400 620 -400 {}
C {lab_pin.sym} 620 -400 0 1 {name=l6 sig_type=std_logic lab=D2}
N 600 -380 620 -380 {}
C {lab_pin.sym} 620 -380 0 1 {name=l7 sig_type=std_logic lab=D1}
N 600 -360 620 -360 {}
C {lab_pin.sym} 620 -360 0 1 {name=l8 sig_type=std_logic lab=D0}
N 600 -340 620 -340 {}
C {lab_pin.sym} 620 -340 0 1 {name=l9 sig_type=std_logic lab=EOC}
N 400 -380 380 -380 {}
C {lab_pin.sym} 380 -380 0 0 {name=l10 sig_type=std_logic lab=0}
C {vsource.sym} -300 200 0 0 {name=V1 value="1.8" savecurrent=false}
N -300 170 -300 150 {}
C {lab_pin.sym} -300 150 0 0 {name=l11 sig_type=std_logic lab=VCC}
N -300 230 -300 250 {}
C {lab_pin.sym} -300 250 0 0 {name=l12 sig_type=std_logic lab=0}
C {vsource.sym} -130 200 0 0 {name=V2 value="0.8" savecurrent=false}
N -130 170 -130 150 {}
C {lab_pin.sym} -130 150 0 0 {name=l13 sig_type=std_logic lab=VREF}
N -130 230 -130 250 {}
C {lab_pin.sym} -130 250 0 0 {name=l14 sig_type=std_logic lab=0}
C {vsource.sym} 40 200 0 0 {name=V3 value="0.4" savecurrent=false}
N 40 170 40 150 {}
C {lab_pin.sym} 40 150 0 0 {name=l15 sig_type=std_logic lab=VCM}
N 40 230 40 250 {}
C {lab_pin.sym} 40 250 0 0 {name=l16 sig_type=std_logic lab=0}
C {vsource.sym} 210 200 0 0 {name=V5 value="PWL(0 0.05 10.3n 0.05 10.8n 0.15 20.3n 0.15 20.8n 0.25 30.3n 0.25 30.8n 0.35 40.3n 0.35 40.8n 0.45 50.3n 0.45 50.8n 0.55 60.3n 0.55 60.8n 0.65 70.3n 0.65 70.8n 0.75)" savecurrent=false}
N 210 170 210 150 {}
C {lab_pin.sym} 210 150 0 0 {name=l17 sig_type=std_logic lab=VIN}
N 210 230 210 250 {}
C {lab_pin.sym} 210 250 0 0 {name=l18 sig_type=std_logic lab=0}
C {vsource.sym} 380 200 0 0 {name=VS value="PULSE(0 1.8 10p 50p 50p 3.95n 10n)" savecurrent=false}
N 380 170 380 150 {}
C {lab_pin.sym} 380 150 0 0 {name=l19 sig_type=std_logic lab=SMP}
N 380 230 380 250 {}
C {lab_pin.sym} 380 250 0 0 {name=l20 sig_type=std_logic lab=0}
C {code_shown.sym} -900 -1050 0 0 {name=s1 only_toplevel=false value=".lib /home/ttuser/pdk/sky130A/libs.tech/combined/sky130.lib.spice tt
.option method=gear reltol=1e-4
.control
save all
tran 5p 80n
let code = 4*ceil((v(D2)-0.9)/10) + 2*ceil((v(D1)-0.9)/10) + ceil((v(D0)-0.9)/10)
meas tran code1 find code at=9.9n
meas tran code2 find code at=19.9n
meas tran code3 find code at=29.9n
meas tran code4 find code at=39.9n
meas tran code5 find code at=49.9n
meas tran code6 find code at=59.9n
meas tran code7 find code at=69.9n
meas tran code8 find code at=79.9n
meas tran teoc1 when v(EOC)=0.9 rise=1 from=4n to=10n
meas tran teoc2 when v(EOC)=0.9 rise=1 from=14n to=20n
meas tran teoc3 when v(EOC)=0.9 rise=1 from=24n to=30n
meas tran teoc4 when v(EOC)=0.9 rise=1 from=34n to=40n
meas tran teoc5 when v(EOC)=0.9 rise=1 from=44n to=50n
meas tran teoc6 when v(EOC)=0.9 rise=1 from=54n to=60n
meas tran teoc7 when v(EOC)=0.9 rise=1 from=64n to=70n
meas tran teoc8 when v(EOC)=0.9 rise=1 from=74n to=80n
let ptot = 1.8*(-i(V1)) + 0.8*(-i(V2)) + 0.4*(-i(V3))
meas tran etot integ ptot from=0 to=80n
let e_conv_pJ = etot/8*1e12
let p_uW = etot/80e-9*1e6
print e_conv_pJ p_uW
* conversion time of each code = teocN - (start of period N + SMP width)
plot v(VIN) v(x1.VX) v(x1.VR)
plot v(SMP) v(x1.CLK)+2 v(x1.XB)+4 v(x1.YB)+6 v(EOC)+8
plot v(D2) v(D1)+2 v(D0)+4 v(EOC)+6
plot v(x1.x2.BPA) v(x1.x2.BPB)
plot code v(VIN)
.endc"}
