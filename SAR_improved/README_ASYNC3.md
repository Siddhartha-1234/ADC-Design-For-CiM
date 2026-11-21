# Asynchronous (self-timed) 3-bit SAR — built on sar_adc3_v3

## What changed vs v3

| | v3 (`sar_adc3_v3`) | async (`sar_adc3_async`) |
|---|---|---|
| Timing inputs | 7: SMP, CLK, C2, U2, C1, U1, C0 | **1: SMP** (plus an EOC output) |
| CDAC | `cdac_vcm3` | same `cdac_vcm3`, unchanged |
| Comparator | `latch_comp` (StrongARM + NAND SR latch) | `latch_comp_async`: same StrongARM core, SR latch removed, XB/YB come out |
| Logic | `sar_logic_vcm3` (23 gates) | `sar_logic_async3` (38 gates: 30 NOR2, 6 INV, 1 NAND2, 1 NAND3) |

## Files (all in SAR_improved)
- `sar_adc3_async.sch/.sym`: top cell (comparator + CDAC + logic)
- `sar_logic_async3.sch/.sym`: self-timed SAR logic
- `latch_comp_async.sch/.sym`: comparator with XB/YB outputs
- `nand2_min`, `nand3_min`: new minimum-size cells (`inv_min` and `nor2_min` are reused)
- `TB_SAR3_async.sch`: 8 conversions (VIN = 0.05 … 0.75 V), 10 ns each, SMP 4 ns high. Measures codes, EOC times and energy.
- `async3_timing.png`: simulated timing for VIN = 0.55 V → 101
- `../gen_async3.py`, `../test_async.py`: generator and test scripts

## Logic equations (k = 2, 1, 0)
- VALID = NAND(XB, YB). It is 1 while the comparator shows a decision.
- ACT2 = NOR(SMP, F2), ACT1 = NOR(G2B, F1), ACT0 = NOR(G1B, EOC). At most one ACT is 1 at a time.
- CLK = NAND3(ACT2B, ACT1B, ACT0B), which is ACT2 OR ACT1 OR ACT0.
- Dk latch: set by NOR(ACTkB, YB) (bit = 1), cleared by SMP.
- Nk latch: set by NOR(ACTkB, XB) (bit = 0), cleared by SMP.
- Fk = Dk OR Nk ("bit k decided"). F0 is EOC.
- Gk latch (k = 2, 1): set by NOR(FkB, VALID), meaning bit k is decided and the comparator has reset. Cleared by SMP.
- Capacitor drive: DNA = D2, UPA = N2, EA = F2, EAB = F2B. Cap B uses D1, N1, F1, F1B in the same way.

## Results (ngspice, sky130 BSIM models with a simplified MIM model; not yet on your PDK)
- Codes: 16/16 correct at 30, 10, 8 and 7 ns per conversion (tt, 27 °C). 14/14 inputs 15 mV from every threshold are correct at tt 27 °C, ss 125 °C and ff −40 °C.
- Conversion time from SMP falling to EOC: 3.7–3.95 ns (tt), 5.5 ns (ss, 125 °C), 3.05 ns (ff, −40 °C).
- Fastest tested cycle: 7 ns (2.5 ns sampling + conversion), about 143 MS/s. v3 needed 20 ns (50 MS/s).
- Energy: 0.98 pJ per conversion (comparator 0.31, logic 0.65, CDAC + VREF 0.024). v3 used 0.62–0.64 pJ, but its 7 timing signals came from ideal sources and are not counted.
- Transistors: 173 (v3: 125). Gate area: 20.1 µm² (v3: 16.7). MIM area unchanged.
- No separate settling delay is needed. The reset half of the loop (about 0.5 ns) already lets VX settle. The settling error at the next clock edge is ≤ 2.4 mV (LSB = 100 mV) at all three corners, compared against a version with a long delay.
- Near-tie test (VIN = 0.385 … 0.415 V in 1 mV steps): no stalls. Conversion time grows to 4.14 ns 1 mV from the threshold. The measured threshold is ≈ 0.3955 V, an offset of about −4.5 mV.

## Limits
- D2–D0 are cleared when SMP rises, so the code must be read between EOC and the next SMP.
- There is no metastability timeout. A comparator that never decides is cleared by the next SMP, and the unfinished bits read 0 (an error of at most 1 LSB).
- Energy is about 55% higher than v3. Every latch toggles every conversion, there are more gates, and the comparator clock is now generated (and counted) on chip.
- Not yet run on your PDK, with Monte Carlo, or with layout parasitics.
