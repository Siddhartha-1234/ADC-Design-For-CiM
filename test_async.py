"""Test the asynchronous 3-bit SAR: one SMP pulse per conversion, nothing else.
usage: python3 test_async.py tag period_ns smp_ns [levels: std | edge]"""
import sys, json
import os
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from simlib import *

SCH = "/home/ttuser/Documents/ADCAnalogDesign/SAR_improved/sar_adc3_async.sch"
TOP = "sar_adc3_async"


def run_async(period, tsmp, levels=None, tag="as", save=None, vref=0.8, vcm=0.4, split=None, extra="", models=None, temp=27):
    lib = subckts(netlist(SCH))
    nets = []
    if split:
        lib, nets = split_supply(lib, TOP, split)
    levels = levels or ORDER
    exp = [min(7, max(0, int(v // 0.1))) for v in levels]
    N = len(levels)
    P, Ts = period * 1e-9, tsmp * 1e-9
    T = N * P
    cir = [models or MODELS, f".option method=gear reltol=1e-4 temp={temp}", lib, "V1 VCC 0 1.8", f"V2 VREF 0 {vref}", f"V3 VCM 0 {vcm}",
           f"V5 VIN 0 {pwl_steps(levels, P, 0.3e-9)}",
           f"VS SMP 0 PULSE(0 1.8 10p 50p 50p {Ts-50e-12:.4e} {P:.4e})", extra]
    cir += [f"V_{n} {n} 0 1.8" for n in nets]
    cir += [f"x1 VCC 0 VREF VCM VIN SMP D2 D1 D0 EOC " + " ".join(nets) + f" {TOP}",
            ".control", "set noaskquit", f"tran {min(P/2000, 5e-12):.3e} {T:.4e}", CODE,
            "let pvcc = 1.8*(-i(V1))", f"let pref = {vref}*(-i(V2))", f"let pcm = {vcm}*(-i(V3))", "let pin = v(VIN)*(-i(V5))",
            f"meas tran e_vcc integ pvcc from=0 to={T:.4e}", f"meas tran e_ref integ pref from=0 to={T:.4e}",
            f"meas tran e_cm integ pcm from=0 to={T:.4e}", f"meas tran e_in integ pin from=0 to={T:.4e}",
            "let dvx = v(x1.VX)-v(x1.VR)", "let both = v(D2)*v(x1.N2) + v(D1)*v(x1.N1)",
            "let both0 = v(D0)*v(x1.x3.N0)",
            f"meas tran bothmax max both from=1n to={T:.4e}", f"meas tran both0max max both0 from=1n to={T:.4e}"]
    for i in range(N):
        t0 = i * P
        cir.append(f"meas tran c{i} find code at={t0 + P - 0.1e-9:.4e}")
        cir.append(f"meas tran teoc{i} when v(EOC)=0.9 rise=1 from={t0 + Ts:.4e} to={t0 + P:.4e}")
        for b in (1, 2, 3):
            cir.append(f"meas tran dv{i}_{b} find dvx when v(x1.CLK)=0.9 rise={b} from={t0 + Ts:.4e}")
    for n in nets:
        cir += [f"let p_{n.lower()} = 1.8*(-i(V_{n}))", f"meas tran e_{n.lower()} integ p_{n.lower()} from=0 to={T:.4e}"]
    if save:
        cir.append(f"wrdata {save} v(VIN) v(x1.VX) v(x1.VR) v(SMP) v(x1.CLK) v(x1.XB) v(x1.YB) v(x1.x3.VALID) "
                   "v(x1.x3.ACT2) v(x1.x3.ACT1) v(x1.x3.ACT0) v(x1.x3.G2) v(x1.x3.G1) v(x1.x3.G2DB) v(x1.x3.G1DB) "
                   "v(D2) v(D1) v(D0) v(EOC) v(x1.x2.BPA) v(x1.x2.BPB) code")
    cir += [".endc", ".end"]
    out = run("\n".join(cir), f"{tag}")
    m = meas(out)
    codes = [round(m.get(f"c{i}", -9)) for i in range(N)]
    teoc = [m.get(f"teoc{i}", float("nan")) - (i * P + Ts) for i in range(N)]
    E = {k: m.get(f"e_{k}", float("nan")) / N * 1e12 for k in ("vcc", "ref", "cm", "in")}
    tot = E["vcc"] + E["ref"] + E["cm"]
    return dict(period=period, tsmp=tsmp, ok=codes == exp, nwrong=sum(a != b for a, b in zip(codes, exp)), codes=codes, exp=exp,
                tconv_ns=[t * 1e9 for t in teoc], tconv_max=max(t * 1e9 for t in teoc) if all(t == t for t in teoc) else float("nan"),
                E_tot_pJ=tot, E_vcc_pJ=E["vcc"], E_ref_pJ=E["ref"], E_cm_pJ=E["cm"], E_in_pJ=E["in"],
                both_max=m.get("bothmax"), both0_max=m.get("both0max"),
                dv=[[m.get(f"dv{i}_{b}", float("nan")) for b in (1, 2, 3)] for i in range(N)], split_pJ={n: m.get(f'e_{n.lower()}', float('nan')) / N * 1e12 for n in nets}, err=errors(out))


if __name__ == "__main__":
    tag, per, ts = sys.argv[1], float(sys.argv[2]), float(sys.argv[3])
    r = run_async(per, ts, tag=tag, save=f"{SIM}/{tag}.txt")
    print(json.dumps({k: v for k, v in r.items()}, indent=None))
