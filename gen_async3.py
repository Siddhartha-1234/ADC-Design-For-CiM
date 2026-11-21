"""Asynchronous (self-timed) 3-bit SAR ADC built on the final v3 design (sar_adc3_v3).

Same CDAC (cdac_vcm3, your copy in SAR_improved) and the same StrongARM latch core.  What changes:
  * the 7 external timing signals (SMP, CLK, C2, U2, C1, U1, C0) become ONE input, SMP;
  * the comparator clock CLK is made inside the ADC by a self-timed loop;
  * an EOC (end of conversion) output says when the code is ready.

usage: python3 gen_async3.py [dly_L dly_capW]   (sizes of the settling-delay cell)"""
import sys
import os
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from xs import *

D = OUTDIR
A = [a for a in sys.argv[1:] if not a.startswith("--")]
DLY_L = float(A[0]) if A else 0.0          # channel length of the slow pull-down in the delay cell (um)
DLY_CW = float(A[1]) if len(A) > 1 else 1.0  # width of the MOS load capacitor in the delay cell (um, L = 1 um)

INV = OUTDIR + "/inv_min.sym"
NOR = OUTDIR + "/nor2_min.sym"
UINV = BASE + "/inverter.sym"               # your inverter (W = 1 um), as used inside latch_comp
SYMS[INV] = SYMS[UINV]
SYMS[NOR] = SYMS[BASE + "/nor2.sym"]
NAND = OUTDIR + "/nand2_min.sym"
SYMS[NAND] = SYMS[BASE + "/nand2.sym"]
NAND3 = OUTDIR + "/nand3_min.sym"
DLY = OUTDIR + "/dly_cell.sym"
WN, WP = 0.42, 0.84


def cells():
    import shutil
    # nand2_min: same symbol and pins as your nand2.sym
    s = Sch("nand2_min: minimum-size NAND2 (PMOS 0.84/0.15 in parallel, NMOS 0.84/0.15 in series).  Same symbol and pins as nand2.sym.")
    s.mos("pfet_01v8", "M1", 100, -250, WP, 0.15, "Y", "A", "VCC", "VCC")
    s.mos("pfet_01v8", "M2", 400, -250, WP, 0.15, "Y", "B", "VCC", "VCC")
    s.mos("nfet_01v8", "M3", 250, 0, 0.84, 0.15, "Y", "A", "N1", "VSS")
    s.mos("nfet_01v8", "M4", 250, 200, 0.84, 0.15, "N1", "B", "VSS", "VSS")
    s.pins(["A", "B"], ["Y"], ["VCC", "VSS"])
    s.save(f"{D}/nand2_min.sch")
    shutil.copy(BASE + "/nand2.sym", f"{D}/nand2_min.sym")
    # nand3_min
    s = Sch("nand3_min: minimum-size NAND3 (PMOS 0.84/0.15 in parallel, NMOS 1.26/0.15 in series).  Y = 0 only when A = B = C = 1.")
    for k, p in enumerate("ABC"):
        s.mos("pfet_01v8", f"MP{p}", 100 + 300 * k, -300, WP, 0.15, "Y", p, "VCC", "VCC")
    s.mos("nfet_01v8", "MNA", 400, -50, 1.26, 0.15, "Y", "A", "N1", "VSS")
    s.mos("nfet_01v8", "MNB", 400, 150, 1.26, 0.15, "N1", "B", "N2", "VSS")
    s.mos("nfet_01v8", "MNC", 400, 350, 1.26, 0.15, "N2", "C", "VSS", "VSS")
    s.pins(["A", "B", "C", "VCC", "VSS"], ["Y"])
    s.save(f"{D}/nand3_min.sch")
    box_sym(f"{D}/nand3_min.sym", ["A", "B", "C", "VCC", "VSS"], ["Y"], "NAND3", width=100)


def dly_cell():
    s = Sch(f"dly_cell: rising-edge delay.  OUTB = NAND(IN, IN delayed).\n"
            f"IN rises -> OUTB falls only after the delay (slow pull-down MN1, L = {DLY_L} um, into the MOS capacitor MC, W = {DLY_CW} um, L = 1 um).\n"
            "IN falls -> OUTB rises at once (the NAND sees IN = 0 directly), so the cell resets fast when SMP clears the latches.\n"
            "Use: gives the CDAC time to settle after a capacitor moves, before the comparator is clocked again.")
    s.mos("pfet_01v8", "MP1", 100, -250, WN, 0.15, "D1", "IN", "VCC", "VCC")
    s.mos("nfet_01v8", "MN1", 100, 0, WN, DLY_L, "D1", "IN", "VSS", "VSS")
    s.mos("nfet_01v8", "MC", 400, 0, DLY_CW, 1, "VSS", "D1", "VSS", "VSS")
    s.inst(INV, "x1", 800, -100, {"IN": "D1", "out": "D2", "VDD": "VCC", "VSS": "VSS"})
    s.inst(NAND, "x2", 1200, -100, {"A": "IN", "B": "D2", "Y": "OUTB", "VCC": "VCC", "VSS": "VSS"})
    s.pins(["IN"], ["OUTB"], ["VCC", "VSS"])
    s.save(f"{D}/dly_cell.sch")
    box_sym(f"{D}/dly_cell.sym", ["IN", "VCC", "VSS"], ["OUTB"], "delay", width=100)


def latch_comp_async(name="latch_comp_async"):
    """Your latch_comp (SAR_improved) with the NAND SR latch removed: XB and YB come out directly."""
    s = Sch(
        f"{name}: the same PMOS-input StrongARM latch as latch_comp, without the NAND SR latch at the output.\n"
        "CLK = 0: reset, X = Y = 0, so XB = YB = 1.   CLK = 1: evaluate, ONE of X, Y goes to VDD.\n"
        "YB falls  <=>  INP > INN (VX > VR, bit = 1).     XB falls  <=>  INP < INN (VX < VR, bit = 0).\n"
        "In the self-timed SAR, 'one of XB, YB is low' means 'the decision is finished' (VALID = NAND(XB, YB)),\n"
        "and the SAR logic latches the bit itself, so the comparator's own SR latch is no longer needed.")
    s.inst(UINV, "x5", -600, -200, {"IN": "CLK", "out": "CLKB", "VDD": "VDD", "VSS": "VSS"})
    s.mos("pfet_01v8", "M7", 300, -600, 2, 0.15, "TAIL", "CLKB", "VDD", "VDD")
    s.mos("pfet_01v8", "M1", 100, -400, 2, 0.5, "P", "INP", "TAIL", "VDD")
    s.mos("pfet_01v8", "M2", 500, -400, 2, 0.5, "Q", "INN", "TAIL", "VDD")
    s.mos("pfet_01v8", "M3", 100, -200, 1, 0.15, "X", "Y", "P", "VDD")
    s.mos("pfet_01v8", "M4", 500, -200, 1, 0.15, "Y", "X", "Q", "VDD")
    s.mos("nfet_01v8", "M5", 100, 0, 0.5, 0.15, "X", "Y", "VSS", "VSS")
    s.mos("nfet_01v8", "M6", 500, 0, 0.5, 0.15, "Y", "X", "VSS", "VSS")
    for k, n in enumerate(("P", "Q", "X", "Y")):
        s.mos("nfet_01v8", f"MR{k+1}", 900 + 220 * k, -300, 0.5, 0.15, n, "CLKB", "VSS", "VSS")
    s.inst(UINV, "x3", 1000, 250, {"IN": "X", "out": "XB", "VDD": "VDD", "VSS": "VSS"})
    s.inst(UINV, "x4", 1000, 550, {"IN": "Y", "out": "YB", "VDD": "VDD", "VSS": "VSS"})
    s.pins(["VDD", "VSS", "CLK", "INP", "INN"], ["XB", "YB"])
    s.save(f"{D}/{name}.sch")
    box_sym(f"{D}/{name}.sym", ["VDD", "VSS", "CLK", "INP", "INN"], ["XB", "YB"], "StrongARM (async)", width=160)


def sar_logic_async3(name="sar_logic_async3"):
    s = Sch(
        f"{name}: self-timed SAR logic for the 3-bit Vcm-switching SAR.  Only SMP comes from outside.\n"
        "Per bit k: two set-reset latches (dual rail):  Dk = 'decision was 1' (set when ACTk and YB low),  Nk = 'decision was 0' (set when ACTk and XB low).\n"
        "Fk = Dk OR Nk = 'bit k is decided'.  Gk = 'bit k decided AND comparator has reset' (set when Fk = 1 and VALID = 0).\n"
        "ACT2 = NOT SMP AND NOT F2,  ACT1 = G2 AND NOT F1,  ACT0 = G1 AND NOT F0.   CLK = ACT2 OR ACT1 OR ACT0.   EOC = F0.   SMP = 1 clears every latch.\n"
        "Loop: CLK up -> comparator decides -> Dk or Nk sets (capacitor k moves at once) -> Fk = 1 -> ACTk = 0 -> CLK down -> comparator resets\n"
        "-> VALID = 0 -> Gk sets -> ACT(k-1) = 1 -> CLK up for the next bit.  The reset half-loop (about 0.5 ns) is also the CDAC settling time:\n"
        "simulated settling error at the next clock edge is under 2.5 mV (LSB = 100 mV) in tt, ss/125 C and ff/-40 C.\n"
        "Capacitor drive straight from the latches: DNA = D2, UPA = N2, EA = F2, EAB = F2B (cap B: D1, N1, F1, F1B).")
    s.inst(NAND, "xval", 900, -400, {"A": "XB", "B": "YB", "Y": "VALID", "VCC": "VCC", "VSS": "VSS"})
    s.text("start: SMP falls -> bit 2 is active at once (ACT2 = NOR(SMP, F2)).     VALID = 1 while the comparator shows a decision.", 0, -520, 0.4)
    for row, k in enumerate((2, 1, 0)):
        y = row * 800
        x0 = 0
        FK = "EOC" if k == 0 else f"F{k}"      # F0 is the end-of-conversion output
        s.text(f"bit {k}" + ("  (drives cap A, 2C)" if k == 2 else "  (drives cap B, C)" if k == 1 else "  (last bit, no capacitor; F0 = EOC)"), x0, y - 200, 0.45)
        s.inst(NOR, f"xa{k}", x0 + 200, y, {"A": "SMP" if k == 2 else (f"G{k+1}DB" if DLY_L > 0 else f"G{k+1}B"), "B": FK, "Y": f"ACT{k}", "VCC": "VCC", "VSS": "VSS"})
        s.inst(INV, f"xab{k}", x0 + 550, y + 20, {"IN": f"ACT{k}", "out": f"ACT{k}B", "VDD": "VCC", "VSS": "VSS"})
        s.inst(NOR, f"xsp{k}", x0 + 900, y - 100, {"A": f"ACT{k}B", "B": "YB", "Y": f"SP{k}", "VCC": "VCC", "VSS": "VSS"})
        s.inst(NOR, f"xsn{k}", x0 + 900, y + 150, {"A": f"ACT{k}B", "B": "XB", "Y": f"SN{k}", "VCC": "VCC", "VSS": "VSS"})
        # D latch (decision = 1) and N latch (decision = 0), cleared by SMP
        s.inst(NOR, f"xd{k}", x0 + 1300, y - 200, {"A": "SMP", "B": f"D{k}B", "Y": f"D{k}", "VCC": "VCC", "VSS": "VSS"})
        s.inst(NOR, f"xdb{k}", x0 + 1300, y - 30, {"A": f"SP{k}", "B": f"D{k}", "Y": f"D{k}B", "VCC": "VCC", "VSS": "VSS"})
        s.inst(NOR, f"xn{k}", x0 + 1300, y + 170, {"A": "SMP", "B": f"N{k}B", "Y": f"N{k}", "VCC": "VCC", "VSS": "VSS"})
        s.inst(NOR, f"xnb{k}", x0 + 1300, y + 340, {"A": f"SN{k}", "B": f"N{k}", "Y": f"N{k}B", "VCC": "VCC", "VSS": "VSS"})
        # completion: F = D OR N
        s.inst(NOR, f"xf{k}", x0 + 1750, y, {"A": f"D{k}", "B": f"N{k}", "Y": f"F{k}B", "VCC": "VCC", "VSS": "VSS"})
        s.inst(INV, f"xfi{k}", x0 + 2100, y + 20, {"IN": f"F{k}B", "out": FK, "VDD": "VCC", "VSS": "VSS"})
        if k > 0:
            s.inst(NOR, f"xsg{k}", x0 + 2450, y - 100, {"A": f"F{k}B", "B": "VALID", "Y": f"SG{k}", "VCC": "VCC", "VSS": "VSS"})
            s.inst(NOR, f"xg{k}", x0 + 2850, y - 200, {"A": "SMP", "B": f"G{k}B", "Y": f"G{k}", "VCC": "VCC", "VSS": "VSS"})
            s.inst(NOR, f"xgb{k}", x0 + 2850, y - 30, {"A": f"SG{k}", "B": f"G{k}", "Y": f"G{k}B", "VCC": "VCC", "VSS": "VSS"})
            if DLY_L > 0:
                s.inst(DLY, f"xd{k}d", x0 + 3250, y - 100, {"IN": f"G{k}", "OUTB": f"G{k}DB", "VCC": "VCC", "VSS": "VSS"})
    s.inst(NAND3, "xclk", 2500, 2300, {"A": "ACT2B", "B": "ACT1B", "C": "ACT0B", "Y": "CLK", "VCC": "VCC", "VSS": "VSS"})
    s.text("comparator clock: CLK = ACT2 OR ACT1 OR ACT0  (at most one ACT is high at a time)", 2000, 2150, 0.4)
    ins = ["VCC", "VSS", "SMP", "XB", "YB"]
    outs = ["CLK", "EOC", "D2", "D1", "D0", "N2", "F2", "F2B", "N1", "F1", "F1B"]
    s.pins(ins, outs)
    s.save(f"{D}/{name}.sch")
    box_sym(f"{D}/{name}.sym", ins, outs, "async SAR logic", width=180)


def sar_top_async(name="sar_adc3_async"):
    load_sym(f"{D}/cdac_vcm3.sym")
    s = Sch(
        "ASYNC 3-bit SAR ADC (self-timed version of sar_adc3_v3): same CDAC (cdac_vcm3) and StrongARM core, ONE timing input.\n"
        "SMP = 1: sample VIN on VX (VCM on VR), clear the logic.   SMP falls: the conversion runs by itself, bit 2 -> bit 1 -> bit 0,\n"
        "each comparator decision starting the next one.  EOC rises when D2 D1 D0 are ready; they stay valid until SMP rises again.")
    s.inst(f"{D}/latch_comp_async.sym", "x1", 600, -300, {"VDD": "VCC", "VSS": "VSS", "CLK": "CLK", "INP": "VX", "INN": "VR", "XB": "XB", "YB": "YB"})
    s.inst(f"{D}/cdac_vcm3.sym", "x2", 1300, -300,
           {"VCC": "VCC", "VSS": "VSS", "VREF": "VREF", "VCM": "VCM", "VIN": "VIN", "SMP": "SMP",
            "UPA": "N2", "DNA": "D2", "EA": "F2", "EAB": "F2B", "UPB": "N1", "DNB": "D1", "EB": "F1", "EBB": "F1B", "VX": "VX", "VR": "VR"})
    s.inst(f"{D}/sar_logic_async3.sym", "x3", 2100, -300,
           {p: p for p in ["VCC", "VSS", "SMP", "XB", "YB", "CLK", "EOC", "D2", "D1", "D0", "N2", "F2", "F2B", "N1", "F1", "F1B"]})
    s.text("cap A: UPA = N2 (bit 2 was 0 -> plate to VREF), DNA = D2 (bit 2 was 1 -> plate to 0 V), EA = F2 (plate leaves VCM).  Cap B the same with bit 1.", 300, 0, 0.35)
    ins = ["VCC", "VSS", "VREF", "VCM", "VIN", "SMP"]
    outs = ["D2", "D1", "D0", "EOC"]
    s.pins(ins, outs)
    s.save(f"{D}/{name}.sch")
    box_sym(f"{D}/{name}.sym", ins, outs, "3-bit async SAR", width=160)


def tb_async(name="TB_SAR3_async", period=10, tsmp=4):
    s = Sch(f"{name}: asynchronous 3-bit SAR.  The ONLY timing source is SMP: {tsmp} ns high (sample), then the ADC converts by itself.\n"
            f"{period} ns per conversion.  VIN = 0.05 ... 0.75 V -> expected codes 0 ... 7.  EOC rises when the code is ready (about 4 ns after SMP falls).\n"
            "Compare with TB_SAR3_v3: there, 7 sources (SMP, CLK, C2, U2, C1, U1, C0) set the timing; here 1.")
    s.inst(f"{D}/sar_adc3_async.sym", "x1", 500, -350, {p: p for p in ["VCC", "VREF", "VCM", "VIN", "SMP", "D2", "D1", "D0", "EOC"]} | {"VSS": "0"})
    N = 8
    lv = [0.05 + 0.1 * k for k in range(N)]
    pwl = ["0 0.05"]
    for i in range(1, N):
        t = i * period + 0.3
        pwl += [f"{t:g}n {lv[i-1]:.2f}", f"{t+0.5:g}n {lv[i]:.2f}"]
    s.vsrc("V1", -300, 200, "1.8", "VCC")
    s.vsrc("V2", -130, 200, "0.8", "VREF")
    s.vsrc("V3", 40, 200, "0.4", "VCM")
    s.vsrc("V5", 210, 200, "PWL(" + " ".join(pwl) + ")", "VIN")
    s.vsrc("VS", 380, 200, f"PULSE(0 1.8 10p 50p 50p {tsmp - 0.05:g}n {period}n)", "SMP")
    T = N * period
    ctl = [".lib /home/ttuser/pdk/sky130A/libs.tech/combined/sky130.lib.spice tt", ".option method=gear reltol=1e-4", ".control", "save all",
           f"tran 5p {T}n",
           "let code = 4*ceil((v(D2)-0.9)/10) + 2*ceil((v(D1)-0.9)/10) + ceil((v(D0)-0.9)/10)"]
    for i in range(N):
        ctl.append(f"meas tran code{i+1} find code at={i * period + period - 0.1:g}n")
    for i in range(N):
        ctl.append(f"meas tran teoc{i+1} when v(EOC)=0.9 rise=1 from={i * period + tsmp:g}n to={(i + 1) * period:g}n")
    ctl += ["let ptot = 1.8*(-i(V1)) + 0.8*(-i(V2)) + 0.4*(-i(V3))", f"meas tran etot integ ptot from=0 to={T}n",
            f"let e_conv_pJ = etot/{N}*1e12", f"let p_uW = etot/{T}e-9*1e6", "print e_conv_pJ p_uW",
            "* conversion time of each code = teocN - (start of period N + SMP width)",
            "plot v(VIN) v(x1.VX) v(x1.VR)",
            "plot v(SMP) v(x1.CLK)+2 v(x1.XB)+4 v(x1.YB)+6 v(EOC)+8",
            "plot v(D2) v(D1)+2 v(D0)+4 v(EOC)+6",
            "plot v(x1.x2.BPA) v(x1.x2.BPB)",
            "plot code v(VIN)", ".endc"]
    s.code(-900, -1050, "\n".join(ctl))
    s.save(f"{D}/{name}.sch")


if __name__ == "__main__":
    cells()
    if DLY_L > 0:
        dly_cell()
    latch_comp_async()
    sar_logic_async3()
    sar_top_async()
    tb_async()
    print("async written: dly L", DLY_L, "cap W", DLY_CW)
