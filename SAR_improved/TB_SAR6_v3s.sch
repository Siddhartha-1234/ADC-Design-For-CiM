v {xschem version=3.4.5 file_version=1.2
}
G {}
K {}
V {}
S {}
E {}
T {TB_SAR6_v3s (area-reduced sar_adc6_v3s, 2 x 2 um units, stacked replica): 6-bit SAR (6-bit version of the final v3: top-plate sampling, Vcm-based switching, latch comparator).  175 ns per conversion:
SMP (VIN sampled on VX, VCM on VR, 0-20 ns) -> then one 25 ns cycle per bit: Ck (decide Dk, 4 ns) -> Uk (move bit k's capacitor, 5 ns), k = 5 ... 1 -> C0 (decide D0).
CLK (comparator clock) pulses together with C5 ... C0.  Every time can be scaled by the same factor (tested down to 0.2x).
VIN steps through the centre of every code: (k + 0.5) x 12.5 mV, k = 0 ... 63 -> expected codes 0 ... 63.  The control block prints every code and counts wrong ones.
Energy per conversion = energy from VCC + VREF + VCM / 64 (energy taken from VIN printed separately).} 290 -630 0 0 0.3 0.3 {}
N 370 -520 390 -520 {
lab=VCC}
N 370 -500 390 -500 {
lab=0}
N 370 -480 390 -480 {
lab=VREF}
N 370 -460 390 -460 {
lab=VCM}
N 370 -440 390 -440 {
lab=VIN}
N 370 -420 390 -420 {
lab=SMP}
N 370 -400 390 -400 {
lab=CLK}
N 370 -380 390 -380 {
lab=C5}
N 370 -360 390 -360 {
lab=U5}
N 370 -340 390 -340 {
lab=C4}
N 370 -320 390 -320 {
lab=U4}
N 370 -300 390 -300 {
lab=C3}
N 370 -280 390 -280 {
lab=U3}
N 370 -260 390 -260 {
lab=C2}
N 370 -240 390 -240 {
lab=U2}
N 370 -220 390 -220 {
lab=C1}
N 370 -200 390 -200 {
lab=U1}
N 370 -180 390 -180 {
lab=C0}
N 610 -520 630 -520 {
lab=D5}
N 610 -500 630 -500 {
lab=D4}
N 610 -480 630 -480 {
lab=D3}
N 610 -460 630 -460 {
lab=D2}
N 610 -440 630 -440 {
lab=D1}
N 610 -420 630 -420 {
lab=D0}
N -300 150 -300 170 {
lab=VCC}
N -300 230 -300 250 {
lab=0}
N -130 150 -130 170 {
lab=VREF}
N -130 230 -130 250 {
lab=0}
N 40 150 40 170 {
lab=VCM}
N 40 230 40 250 {
lab=0}
N 210 150 210 170 {
lab=VIN}
N 210 230 210 250 {
lab=0}
N 380 150 380 170 {
lab=CLK}
N 380 230 380 250 {
lab=0}
N 550 150 550 170 {
lab=SMP}
N 550 230 550 250 {
lab=0}
N 720 150 720 170 {
lab=C5}
N 720 230 720 250 {
lab=0}
N 890 150 890 170 {
lab=U5}
N 890 230 890 250 {
lab=0}
N -300 370 -300 390 {
lab=C4}
N -300 450 -300 470 {
lab=0}
N -130 370 -130 390 {
lab=U4}
N -130 450 -130 470 {
lab=0}
N 40 370 40 390 {
lab=C3}
N 40 450 40 470 {
lab=0}
N 210 370 210 390 {
lab=U3}
N 210 450 210 470 {
lab=0}
N 380 370 380 390 {
lab=C2}
N 380 450 380 470 {
lab=0}
N 550 370 550 390 {
lab=U2}
N 550 450 550 470 {
lab=0}
N 720 370 720 390 {
lab=C1}
N 720 450 720 470 {
lab=0}
N 890 370 890 390 {
lab=U1}
N 890 450 890 470 {
lab=0}
N -300 590 -300 610 {
lab=C0}
N -300 670 -300 690 {
lab=0}
C {/home/ttuser/Documents/ADCAnalogDesign/SAR_improved/sar_adc6_v3s.sym} 500 -350 0 0 {name=x1}
C {lab_pin.sym} 370 -520 0 0 {name=l1 sig_type=std_logic lab=VCC}
C {lab_pin.sym} 370 -500 0 0 {name=l2 sig_type=std_logic lab=0}
C {lab_pin.sym} 370 -480 0 0 {name=l3 sig_type=std_logic lab=VREF}
C {lab_pin.sym} 370 -460 0 0 {name=l4 sig_type=std_logic lab=VCM}
C {lab_pin.sym} 370 -440 0 0 {name=l5 sig_type=std_logic lab=VIN}
C {lab_pin.sym} 370 -420 0 0 {name=l6 sig_type=std_logic lab=SMP}
C {lab_pin.sym} 370 -400 0 0 {name=l7 sig_type=std_logic lab=CLK}
C {lab_pin.sym} 370 -380 0 0 {name=l8 sig_type=std_logic lab=C5}
C {lab_pin.sym} 370 -360 0 0 {name=l9 sig_type=std_logic lab=U5}
C {lab_pin.sym} 370 -340 0 0 {name=l10 sig_type=std_logic lab=C4}
C {lab_pin.sym} 370 -320 0 0 {name=l11 sig_type=std_logic lab=U4}
C {lab_pin.sym} 370 -300 0 0 {name=l12 sig_type=std_logic lab=C3}
C {lab_pin.sym} 370 -280 0 0 {name=l13 sig_type=std_logic lab=U3}
C {lab_pin.sym} 370 -260 0 0 {name=l14 sig_type=std_logic lab=C2}
C {lab_pin.sym} 370 -240 0 0 {name=l15 sig_type=std_logic lab=U2}
C {lab_pin.sym} 370 -220 0 0 {name=l16 sig_type=std_logic lab=C1}
C {lab_pin.sym} 370 -200 0 0 {name=l17 sig_type=std_logic lab=U1}
C {lab_pin.sym} 370 -180 0 0 {name=l18 sig_type=std_logic lab=C0}
C {lab_pin.sym} 630 -520 0 1 {name=l19 sig_type=std_logic lab=D5}
C {lab_pin.sym} 630 -500 0 1 {name=l20 sig_type=std_logic lab=D4}
C {lab_pin.sym} 630 -480 0 1 {name=l21 sig_type=std_logic lab=D3}
C {lab_pin.sym} 630 -460 0 1 {name=l22 sig_type=std_logic lab=D2}
C {lab_pin.sym} 630 -440 0 1 {name=l23 sig_type=std_logic lab=D1}
C {lab_pin.sym} 630 -420 0 1 {name=l24 sig_type=std_logic lab=D0}
C {vsource.sym} -300 200 0 0 {name=V1 value="1.8" savecurrent=false}
C {lab_pin.sym} -300 150 0 0 {name=l25 sig_type=std_logic lab=VCC}
C {lab_pin.sym} -300 250 0 0 {name=l26 sig_type=std_logic lab=0}
C {vsource.sym} -130 200 0 0 {name=V2 value="0.8" savecurrent=false}
C {lab_pin.sym} -130 150 0 0 {name=l27 sig_type=std_logic lab=VREF}
C {lab_pin.sym} -130 250 0 0 {name=l28 sig_type=std_logic lab=0}
C {vsource.sym} 40 200 0 0 {name=V3 value="0.4" savecurrent=false}
C {lab_pin.sym} 40 150 0 0 {name=l29 sig_type=std_logic lab=VCM}
C {lab_pin.sym} 40 250 0 0 {name=l30 sig_type=std_logic lab=0}
C {vsource.sym} 210 200 0 0 {name=V5 value="0.53" savecurrent=false}
C {lab_pin.sym} 210 150 0 0 {name=l31 sig_type=std_logic lab=VIN}
C {lab_pin.sym} 210 250 0 0 {name=l32 sig_type=std_logic lab=0}
C {vsource.sym} 380 200 0 0 {name=V4 value="PWL(0 0 24n 0 24.1n 1.8 28n 1.8 28.1n 0 49n 0 49.1n 1.8 53n 1.8 53.1n 0 74n 0 74.1n 1.8 78n 1.8 78.1n 0 99n 0 99.1n 1.8 103n 1.8 103.1n 0 124n 0 124.1n 1.8 128n 1.8 128.1n 0 149n 0 149.1n 1.8 153n 1.8 153.1n 0 175n 0) r=0" savecurrent=false}
C {lab_pin.sym} 380 150 0 0 {name=l33 sig_type=std_logic lab=CLK}
C {lab_pin.sym} 380 250 0 0 {name=l34 sig_type=std_logic lab=0}
C {vsource.sym} 550 200 0 0 {name=V6 value="PULSE(0 1.8 0n 0.1n 0.1n 19.9n 175n)" savecurrent=false}
C {lab_pin.sym} 550 150 0 0 {name=l35 sig_type=std_logic lab=SMP}
C {lab_pin.sym} 550 250 0 0 {name=l36 sig_type=std_logic lab=0}
C {vsource.sym} 720 200 0 0 {name=V7 value="PULSE(0 1.8 24n 0.1n 0.1n 3.9n 175n)" savecurrent=false}
C {lab_pin.sym} 720 150 0 0 {name=l37 sig_type=std_logic lab=C5}
C {lab_pin.sym} 720 250 0 0 {name=l38 sig_type=std_logic lab=0}
C {vsource.sym} 890 200 0 0 {name=V8 value="PULSE(0 1.8 30n 0.1n 0.1n 4.9n 175n)" savecurrent=false}
C {lab_pin.sym} 890 150 0 0 {name=l39 sig_type=std_logic lab=U5}
C {lab_pin.sym} 890 250 0 0 {name=l40 sig_type=std_logic lab=0}
C {vsource.sym} -300 420 0 0 {name=V9 value="PULSE(0 1.8 49n 0.1n 0.1n 3.9n 175n)" savecurrent=false}
C {lab_pin.sym} -300 370 0 0 {name=l41 sig_type=std_logic lab=C4}
C {lab_pin.sym} -300 470 0 0 {name=l42 sig_type=std_logic lab=0}
C {vsource.sym} -130 420 0 0 {name=V10 value="PULSE(0 1.8 55n 0.1n 0.1n 4.9n 175n)" savecurrent=false}
C {lab_pin.sym} -130 370 0 0 {name=l43 sig_type=std_logic lab=U4}
C {lab_pin.sym} -130 470 0 0 {name=l44 sig_type=std_logic lab=0}
C {vsource.sym} 40 420 0 0 {name=V11 value="PULSE(0 1.8 74n 0.1n 0.1n 3.9n 175n)" savecurrent=false}
C {lab_pin.sym} 40 370 0 0 {name=l45 sig_type=std_logic lab=C3}
C {lab_pin.sym} 40 470 0 0 {name=l46 sig_type=std_logic lab=0}
C {vsource.sym} 210 420 0 0 {name=V12 value="PULSE(0 1.8 80n 0.1n 0.1n 4.9n 175n)" savecurrent=false}
C {lab_pin.sym} 210 370 0 0 {name=l47 sig_type=std_logic lab=U3}
C {lab_pin.sym} 210 470 0 0 {name=l48 sig_type=std_logic lab=0}
C {vsource.sym} 380 420 0 0 {name=V13 value="PULSE(0 1.8 99n 0.1n 0.1n 3.9n 175n)" savecurrent=false}
C {lab_pin.sym} 380 370 0 0 {name=l49 sig_type=std_logic lab=C2}
C {lab_pin.sym} 380 470 0 0 {name=l50 sig_type=std_logic lab=0}
C {vsource.sym} 550 420 0 0 {name=V14 value="PULSE(0 1.8 105n 0.1n 0.1n 4.9n 175n)" savecurrent=false}
C {lab_pin.sym} 550 370 0 0 {name=l51 sig_type=std_logic lab=U2}
C {lab_pin.sym} 550 470 0 0 {name=l52 sig_type=std_logic lab=0}
C {vsource.sym} 720 420 0 0 {name=V15 value="PULSE(0 1.8 124n 0.1n 0.1n 3.9n 175n)" savecurrent=false}
C {lab_pin.sym} 720 370 0 0 {name=l53 sig_type=std_logic lab=C1}
C {lab_pin.sym} 720 470 0 0 {name=l54 sig_type=std_logic lab=0}
C {vsource.sym} 890 420 0 0 {name=V16 value="PULSE(0 1.8 130n 0.1n 0.1n 4.9n 175n)" savecurrent=false}
C {lab_pin.sym} 890 370 0 0 {name=l55 sig_type=std_logic lab=U1}
C {lab_pin.sym} 890 470 0 0 {name=l56 sig_type=std_logic lab=0}
C {vsource.sym} -300 640 0 0 {name=V17 value="PULSE(0 1.8 149n 0.1n 0.1n 3.9n 175n)" savecurrent=false}
C {lab_pin.sym} -300 590 0 0 {name=l57 sig_type=std_logic lab=C0}
C {lab_pin.sym} -300 690 0 0 {name=l58 sig_type=std_logic lab=0}
C {code_shown.sym} -900 -1050 0 0 {name=s1 only_toplevel=false value=".lib /home/ttuser/pdk/sky130A/libs.tech/combined/sky130.lib.spice tt
.option method=gear reltol=1e-4
.control
save all
tran 0.05n 11200n
let code = 0*v(D0)
let code = code + 32*ceil((v(D5)-0.9)/10)
let code = code + 16*ceil((v(D4)-0.9)/10)
let code = code + 8*ceil((v(D3)-0.9)/10)
let code = code + 4*ceil((v(D2)-0.9)/10)
let code = code + 2*ceil((v(D1)-0.9)/10)
let code = code + 1*ceil((v(D0)-0.9)/10)
let nwrong = 0
let k = 0
while k < 64
  let tr = k*175e-9 + 165e-9
  meas tran ck find code at=$&tr
  print k ck
  if abs(ck - k) > 0.5
    let nwrong = nwrong + 1
  end
  let k = k + 1
end
print nwrong
let ptot = 1.8*(-i(V1)) + 0.8*(-i(V2)) + 0.4*(-i(V3))
let pin = v(VIN)*(-i(V5))
meas tran etot integ ptot from=0 to=11200n
meas tran ein integ pin from=0 to=11200n
let e_conv_pJ = etot/64*1e12
let e_from_vin_pJ = ein/64*1e12
let p_uW = etot/11200e-9*1e6
print e_conv_pJ p_uW e_from_vin_pJ
plot v(VIN) v(x1.VX) v(x1.VR)
plot v(SMP) v(CLK)+2 v(x1.COM)+4
plot v(x1.x2.BP5) v(x1.x2.BP4) v(x1.x2.BP3) v(x1.x2.BP2) v(x1.x2.BP1)
plot v(D5)+0 v(D4)+2 v(D3)+4 v(D2)+6 v(D1)+8 v(D0)+10
plot code
.endc"}
