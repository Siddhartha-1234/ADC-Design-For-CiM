#!/usr/bin/env python3
"""
make_ppt_figures.py
Makes every graph and schematic image for the review deck ADC_CiM_Review_12Nov.

Run it from your ADC design folder in Ubuntu:

    python3 make_ppt_figures.py                  # search this folder
    python3 make_ppt_figures.py ~/adcdesign      # or name the folder
    python3 make_ppt_figures.py --rerun          # re-simulate even if .raw files exist
    python3 make_ppt_figures.py --only 10,17     # only some slides
    python3 make_ppt_figures.py --map vx=x1.top  # tell it a node name it could not find

Output: a folder  ppt_figures/  with one PNG per slide box, plus REPORT.txt.
Send the whole ppt_figures folder back (REPORT.txt says what worked, which
.raw files and which node names were used, and lists every vector it saw).

Needs: python3 with numpy + matplotlib, ngspice, and (for netlisting / schematic
images) xschem. Install anything missing with:
    sudo apt install python3-numpy python3-matplotlib ngspice

What it makes (file name -> slide box it is for):
    slide05_sar6_conversion.png       6-bit SAR, one conversion: SMP, CLK, VX/VR, COM, D5..D0
    slide06_mim_capacitance.png       sky130 MIM unit capacitance, area vs perimeter part
    slide08_old_comparator.svg/png    old comparator schematic
    slide08_latch.svg/png             StrongARM latch schematic
    slide10_latch_cases.png           latch: CLK, X, Y, COM for the five cases (+ CSV of decision times)
    slide12_old_sar3_timing.png       old 3-bit SAR: CLK, VIN/REF
    slide12_v3_sar3_timing.png        v3 3-bit SAR: SMP, CLK, VX/VR
    slide12_*_schematic.svg/png       both 3-bit SAR schematics
    slide14_kickback_zoom.png         VX and VR around one CLK edge (equal kick)
    slide17_v3_timing.png             v3 3-bit SAR: the 7 timing inputs
    slide17_async3_timing.png         async 3-bit SAR, VIN = 0.55 V -> 101
"""

import argparse
import datetime
import math
import os
import re
import shutil
import struct
import subprocess
import sys
import traceback
from pathlib import Path

import numpy as np
import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt
from matplotlib import font_manager

# =============================================================================
# CONFIG: edit here if the script picks the wrong file or node
# =============================================================================
CONFIG = {
    "vdd": 1.8, "vref": 0.8, "vcm": 0.4,

    # Testbench schematics / netlists / raw files, matched on the file name
    # (without extension, lower case). First regex that matches wins.
    # A name matching an 'exclude' regex is skipped.
    "tb": {
        "sar6":       {"inc": [r"^tb_sar6_v3s$", r"^tb_sar6_v3$", r"^tb_sar_?adc6.*", r"^tb.*sar.*6"],
                       "exc": [r"async", r"mc$"]},
        "sar3_v3":    {"inc": [r"^tb_sar3_v3n?$", r"^tb_sar_?adc3_v3", r"^tb.*sar.*3.*v3"],
                       "exc": [r"async", r"mc$"]},
        "sar3_old":   {"inc": [r"^tb_sar_?adc3$", r"^tb_sar3$", r"^tb_sar$", r"^tb.*sar.*3$"],
                       "exc": [r"v\d", r"async", r"6", r"mc$"]},
        "sar3_async": {"inc": [r"^tb_sar3_async$", r"^tb.*sar.*async"], "exc": [r"mc$"]},
    },

    # Schematics for the image boxes
    "sch": {
        "old_comparator": {"inc": [r"^comparator$", r"^comp$", r"^comparator_ct"], "exc": [r"^tb", r"latch"]},
        "latch":          {"inc": [r"^latch_comp$", r"^latch_comp_v3", r"strongarm", r"^latch"],
                           "exc": [r"^tb", r"async", r"_mc$"]},
        "sar3_old":       {"inc": [r"^sar_adc3$", r"^sar3$"], "exc": [r"^tb"]},
        "sar3_v3":        {"inc": [r"^sar_adc3_v3n?$", r"^sar3_v3"], "exc": [r"^tb"]},
    },

    # Subcircuit name of the v3 latch (with SR latch) inside the netlists.
    "latch_subckt": [r"^latch_comp$", r"^latch_comp_v3", r"strongarm", r"latch"],
    "latch_subckt_exc": [r"async", r"^sr", r"sr_?latch", r"^tb"],
    # Force a latch pin mapping here if the guess is wrong, e.g.
    # {"inp": "inp", "inn": "inn", "clk": "clk", "clkb": "clkb", "vdd": "vdd", "gnd": "gnd"}
    # keys = latch subckt pin names (lower case), values = vdd|gnd|clk|clkb|inp|inn|<any node>
    "latch_pins": {},

    # Which conversion to show: the one whose sampled VIN is nearest to this.
    "vin_target": {"sar6": 0.53, "sar3_v3": 0.55, "sar3_old": 0.55, "sar3_async": 0.55},

    # Slide 10 cases: (label, VX, VR)
    "latch_cases": [("Bottom of range", 0.05, 0.4), ("Top of range", 0.79, 0.4),
                    ("Last bit, above", 0.40625, 0.4), ("Last bit, below", 0.39375, 0.4),
                    ("Near tie", 0.4005, 0.4)],

    # MIM sizes (square, um) to simulate for slide 6, and the three shown
    "mim_sizes": [1, 1.5, 2, 3, 4, 5, 6, 8, 10],
    "mim_show": [2, 4, 8],

    # Node-name overrides: role -> exact vector name in the .raw (also --map role=name)
    "map": {},
}

# Candidate node names per role. Matching ignores case, v( ), [ ], _ and < >,
# and also accepts the last part of a hierarchical name (x1.vx -> vx).
ROLE = {
    "smp":   ["smp", "sample", "samp", "sh", "phi_s", "phis"],
    "clk":   ["clk", "clkcomp", "clkc", "clk_comp", "ck", "clk_int", "clkint"],
    "clkb":  ["clkb", "clkn", "nclk", "clkbar"],
    "vx":    ["vx", "vtop", "top", "vcdac", "cdactop", "vxp", "dacp"],
    "vr":    ["vr", "vrep", "vref_rep", "replica", "vxn", "dacn"],
    "vin":   ["vin", "ain", "vi", "in"],
    "ref":   ["ref", "vrefdac", "vdac", "dacout", "vdacout", "dac"],
    "com":   ["com", "comp", "cmp", "compout", "cout"],
    "comb":  ["comb", "compb", "coutb"],
    "eoc":   ["eoc", "done", "ready"],
    "valid": ["valid", "vld"],
    "x":     ["x", "outp", "op", "dp", "xi"],
    "y":     ["y", "outn", "on", "dn", "yi"],
    "xb":    ["xb"],
    "yb":    ["yb"],
}
for _k in range(8):
    ROLE[f"d{_k}"] = [f"d{_k}", f"b{_k}", f"dout{_k}", f"bit{_k}", f"code{_k}", f"q{_k}", f"out{_k}"]
    ROLE[f"c{_k}"] = [f"c{_k}"]
    ROLE[f"u{_k}"] = [f"u{_k}"]
    ROLE[f"act{_k}"] = [f"act{_k}"]
    ROLE[f"n{_k}"] = [f"n{_k}"]
    ROLE[f"g{_k}"] = [f"g{_k}"]
    ROLE[f"f{_k}"] = [f"f{_k}"]

# Slide paste-box sizes in inches (width, height) so images drop in without resizing
BOX = {
    "s05": (7.6, 4.45), "s06": (11.55, 1.6), "s10": (10.0, 2.6), "s12": (5.3, 2.05),
    "s14": (7.45, 1.4), "s17": (5.3, 2.3), "s17a": (5.3, 2.3),
}
DPI = 250

# Deck colours
NAVY, BLUE, RUST, GREEN, MUTED, GRID = "#13203A", "#2563B8", "#B4531A", "#2E7D4F", "#6B7480", "#E3E5E8"

# =============================================================================
# Small helpers
# =============================================================================
LOG = []


def log(msg):
    print(msg)
    LOG.append(msg)


def norm(name):
    n = name.strip().lower()
    m = re.match(r"^v\((.*)\)$", n)
    if m:
        n = m.group(1)
    return re.sub(r"[\[\]<>_]", "", n)


def setup_style():
    names = {f.name for f in font_manager.fontManager.ttflist}
    family = "IBM Plex Sans" if "IBM Plex Sans" in names else "DejaVu Sans"
    plt.rcParams.update({
        "font.family": family, "font.size": 7.5, "axes.titlesize": 8, "axes.labelsize": 7.5,
        "xtick.labelsize": 7, "ytick.labelsize": 7, "legend.fontsize": 7,
        "axes.edgecolor": "#9AA3AE", "axes.linewidth": 0.6, "axes.labelcolor": NAVY,
        "xtick.color": MUTED, "ytick.color": MUTED, "axes.grid": True, "grid.color": GRID,
        "grid.linewidth": 0.5, "axes.spines.top": False, "axes.spines.right": False,
        "savefig.facecolor": "white", "figure.facecolor": "white", "lines.linewidth": 1.1,
    })


def run(cmd, cwd=None, timeout=900):
    try:
        p = subprocess.run(cmd, cwd=cwd, capture_output=True, text=True, timeout=timeout)
        return p.returncode, p.stdout + p.stderr
    except FileNotFoundError:
        return 127, f"not found: {cmd[0]}"
    except subprocess.TimeoutExpired:
        return 124, f"timeout after {timeout}s: {' '.join(cmd)}"


# =============================================================================
# ngspice raw-file reader (binary and ascii, real and complex)
# =============================================================================
def read_raw(path):
    """Return list of plots: {'name', 'vars': [names], 'data': {name: np.array}}"""
    blob = Path(path).read_bytes()
    plots, pos = [], 0
    while pos < len(blob):
        hdr = {}
        varnames = []
        nvars = npts = 0
        mode = None
        while pos < len(blob):
            end = blob.find(b"\n", pos)
            if end < 0:
                end = len(blob)
            line = blob[pos:end].decode("latin-1").rstrip("\r")
            pos = end + 1
            if not line.strip():
                continue
            key, _, val = line.partition(":")
            k = key.strip().lower()
            if k == "plotname":
                hdr["name"] = val.strip()
            elif k == "flags":
                hdr["flags"] = val.strip().lower()
            elif k == "no. variables":
                nvars = int(val)
            elif k == "no. points":
                npts = int(val)
            elif k == "variables":
                for _ in range(nvars):
                    end = blob.find(b"\n", pos)
                    parts = blob[pos:end].decode("latin-1").split()
                    pos = end + 1
                    varnames.append(parts[1] if len(parts) > 1 else parts[0])
            elif k in ("binary", "values"):
                mode = k
                break
        if mode is None or nvars == 0:
            break
        cplx = "complex" in hdr.get("flags", "")
        if mode == "binary":
            width = 16 if cplx else 8
            nbytes = nvars * npts * width
            arr = np.frombuffer(blob[pos:pos + nbytes], dtype="<f8")
            pos += nbytes
            if cplx:
                arr = arr.reshape(npts, nvars, 2)
                arr = arr[..., 0] + 1j * arr[..., 1]
            else:
                arr = arr.reshape(npts, nvars)
        else:
            vals = []
            text_end = blob.find(b"\nTitle:", pos)
            if text_end < 0:
                text_end = blob.find(b"\nPlotname:", pos)
            chunk = blob[pos:text_end if text_end > 0 else len(blob)].decode("latin-1")
            pos = text_end + 1 if text_end > 0 else len(blob)
            toks = chunk.split()
            i = 0
            for _ in range(npts):
                i += 1  # point index
                row = []
                for _v in range(nvars):
                    t = toks[i]
                    i += 1
                    if cplx:
                        re_, im_ = t.split(",")
                        row.append(complex(float(re_), float(im_)))
                    else:
                        row.append(float(t))
                vals.append(row)
            arr = np.array(vals)
        data = {varnames[j]: arr[:, j] for j in range(nvars)}
        plots.append({"name": hdr.get("name", ""), "vars": varnames, "data": data})
    return plots


def tran_plot(path):
    for p in read_raw(path):
        if any(v.lower() == "time" for v in p["vars"]):
            d = {k.lower(): np.real(v) for k, v in p["data"].items()}
            return d
    raise RuntimeError(f"no transient plot in {path}")


# =============================================================================
# Signal lookup
# =============================================================================
class Signals:
    def __init__(self, data, label):
        self.d = data
        self.t = data["time"]
        self.label = label
        self.used = {}
        self.index = {}
        for name in data:
            if name.startswith("i(") or "#branch" in name or name == "time":
                continue
            n = norm(name)
            last = n.split(".")[-1]
            depth = n.count(".")
            self.index.setdefault(("full", n), []).append((depth, name))
            self.index.setdefault(("last", last), []).append((depth, name))

    def find(self, role, required=False):
        override = CONFIG["map"].get(role)
        if override:
            key = override.lower()
            if key in self.d:
                self.used[role] = key
                return self.d[key]
            for name in self.d:
                if norm(name) == norm(override):
                    self.used[role] = name
                    return self.d[name]
        for cand in ROLE.get(role, [role]):
            c = norm(cand)
            for kind in ("full", "last"):
                hits = sorted(self.index.get((kind, c), []))
                if hits:
                    name = hits[0][1]
                    self.used[role] = name
                    return self.d[name]
        if required:
            raise KeyError(f"{self.label}: no vector for '{role}' (tried {ROLE.get(role, [role])}). "
                           f"Fix with --map {role}=<name>; see vector list in REPORT.txt")
        return None


def edges(t, y, th, rising=True):
    b = y > th
    idx = np.where((~b[:-1] & b[1:]) if rising else (b[:-1] & ~b[1:]))[0]
    out = []
    for i in idx:
        y0, y1 = y[i], y[i + 1]
        frac = (th - y0) / (y1 - y0) if y1 != y0 else 0.0
        out.append(t[i] + frac * (t[i + 1] - t[i]))
    return np.array(out)


def val_at(t, y, tq):
    return float(np.interp(tq, t, y))


def pick_conversion(S, target):
    """Return (t_start, t_end, t_smp_fall, vin_sampled) of the conversion nearest target."""
    th = CONFIG["vdd"] / 2
    t = S.t
    smp = S.find("smp")
    vin = S.find("vin")
    vx = S.find("vx")
    if smp is not None and np.ptp(smp) > th:
        rises, falls = edges(t, smp, th, True), edges(t, smp, th, False)
        best = None
        for tf in falls:
            nxt = rises[rises > tf]
            t_end = nxt[0] if len(nxt) else t[-1]
            prv = rises[rises < tf]
            t_start = prv[-1] if len(prv) else max(t[0], tf - 0.1 * (t_end - tf))
            if vin is not None:
                v = val_at(t, vin, tf - 1e-12)
            elif vx is not None:
                v = val_at(t, vx, tf - 1e-12)
            else:
                v = float("nan")
            score = abs(v - target) if not math.isnan(v) else 0
            if best is None or score < best[0]:
                best = (score, t_start, t_end, tf, v)
        if best:
            return best[1:]
    if vin is not None:
        dv = np.abs(np.diff(vin))
        cuts = np.where(dv > 1e-3)[0]
        bounds = [0] + list(cuts + 1) + [len(t) - 1]
        segs = [(bounds[i], bounds[i + 1]) for i in range(len(bounds) - 1) if bounds[i + 1] > bounds[i] + 2]
        if 1 <= len(segs) <= 300:
            a, b = min(segs, key=lambda s: abs(float(np.mean(vin[s[0]:s[1]])) - target))
            return t[a], t[b - 1], t[a], float(np.mean(vin[a:b]))
    return t[0], t[-1], t[0], float(vin[0]) if vin is not None else float("nan")


def time_unit(span):
    if span < 2e-9:
        return 1e12, "ps"
    if span < 5e-6:
        return 1e9, "ns"
    return 1e6, "µs"


def window(S, y, a, b):
    m = (S.t >= a) & (S.t <= b)
    return S.t[m], y[m]


def code_at(S, bits, tq):
    out = ""
    for k in bits:
        y = S.find(f"d{k}")
        out += ("1" if val_at(S.t, y, tq) > CONFIG["vdd"] / 2 else "0") if y is not None else "?"
    return out


def logic_axis(ax, S, roles, labels, a, b, scale, colors=None):
    """Draw several digital signals stacked like a logic analyser."""
    vdd = CONFIG["vdd"]
    shown = []
    for role, lab in zip(roles, labels):
        y = S.find(role)
        if y is not None:
            shown.append((lab, y))
    n = len(shown)
    for i, (lab, y) in enumerate(shown):
        off = n - 1 - i
        tt, yy = window(S, y, a, b)
        col = (colors or {}).get(lab, NAVY)
        ax.plot((tt - a) * scale, off + 0.72 * np.clip(yy / vdd, 0, 1.1), color=col, lw=0.9)
    ax.set_yticks([n - 1 - i + 0.36 for i in range(n)])
    ax.set_yticklabels([lab for lab, _ in shown], fontsize=6.5, color=NAVY)
    ax.set_ylim(-0.25, n)
    ax.grid(axis="y", visible=False)
    ax.tick_params(axis="y", length=0)
    return [lab for lab, _ in shown]


def save(fig, out, name):
    p = out / name
    fig.savefig(p, dpi=DPI, bbox_inches="tight", pad_inches=0.04)
    plt.close(fig)
    log(f"  wrote {p.name}")
    return p


# =============================================================================
# Finding files, netlisting, simulating
# =============================================================================
class Project:
    def __init__(self, root, out, rerun):
        self.root = root
        self.out = out
        self.work = out / "_work"
        self.work.mkdir(parents=True, exist_ok=True)
        self.rerun = rerun
        self.files = []
        skip = {".git", "ppt_figures", "__pycache__"}
        roots = [root, Path.home() / ".xschem" / "simulations"]
        for r in roots:
            if not r.exists():
                continue
            for dp, dns, fns in os.walk(r):
                dns[:] = [d for d in dns if d not in skip and not d.startswith(".")]
                for f in fns:
                    self.files.append(Path(dp) / f)
        self.lib_line = None
        self.used_raws = []

    def find(self, spec, exts):
        cands = [f for f in self.files if f.suffix.lower() in exts]
        for rx in spec["inc"]:
            hits = [f for f in cands if re.search(rx, f.stem.lower())
                    and not any(re.search(e, f.stem.lower()) for e in spec.get("exc", []))]
            if hits:
                hits.sort(key=lambda f: -f.stat().st_mtime)
                return hits[0]
        return None

    def netlist(self, key):
        """Get a SPICE netlist for testbench `key`: existing .spice or xschem -n."""
        spec = CONFIG["tb"][key]
        sch = self.find(spec, {".sch"})
        if sch and shutil.which("xschem"):
            outdir = self.work / f"net_{key}"
            outdir.mkdir(exist_ok=True)
            rc, msg = run(["xschem", "-n", "-s", "-q", "-x", "-o", str(outdir), str(sch)], cwd=sch.parent, timeout=120)
            nets = sorted(outdir.glob("*.spice"), key=lambda f: -f.stat().st_mtime)
            if nets:
                log(f"  netlisted {sch.name} with xschem")
                return nets[0]
            log(f"  xschem netlist of {sch.name} failed ({rc}): {msg.strip()[-300:]}")
        net = self.find(spec, {".spice", ".cir", ".sp", ".net"})
        if net:
            log(f"  using existing netlist {net}")
            return net
        return None

    def raw(self, key):
        spec = CONFIG["tb"][key]
        if not self.rerun:
            r = self.find(spec, {".raw"})
            if r:
                log(f"  using existing raw {r}")
                if r not in self.used_raws:
                    self.used_raws.append(r)
                return r
        net = self.netlist(key)
        if net is None:
            raise FileNotFoundError(f"no .raw, .sch or netlist found for '{key}' "
                                    f"(patterns {spec['inc']}). Edit CONFIG['tb']['{key}'].")
        return self.simulate(net, key)

    def simulate(self, net, key):
        text = Path(net).read_text(errors="replace")
        self.grab_lib(text)
        rawp = (self.work / f"{key}.raw").resolve()
        if rawp.exists():
            rawp.unlink()
        lines = text.splitlines()
        if any(l.strip().lower().startswith(".control") for l in lines):
            new = []
            in_ctl = False
            for l in lines:
                s = l.strip().lower()
                if s.startswith(".control"):
                    in_ctl = True
                    new.append(l)
                    continue
                if in_ctl and (s in ("quit", "exit") or s.startswith(".endc")):
                    new.append(f"write {rawp}")
                    if s.startswith(".endc"):
                        in_ctl = False
                if in_ctl and s.startswith("write "):
                    continue
                new.append(l)
            netp = self.work / f"{key}_run.spice"
            netp.write_text("\n".join(new) + "\n")
            cmd = ["ngspice", "-b", str(netp)]
        else:
            netp = self.work / f"{key}_run.spice"
            netp.write_text(text)
            cmd = ["ngspice", "-b", "-r", str(rawp), str(netp)]
        log(f"  simulating {key} with ngspice (can take a few minutes) ...")
        rc, msg = run(cmd, cwd=Path(net).parent)
        (self.work / f"{key}_ngspice.log").write_text(msg)
        if not rawp.exists():
            raise RuntimeError(f"ngspice produced no raw for {key} (rc {rc}); see _work/{key}_ngspice.log")
        self.used_raws.append(rawp)
        return rawp

    def grab_lib(self, text):
        if self.lib_line:
            return
        for l in text.splitlines():
            if re.match(r"^\s*\.lib\s+\S*sky130\S*", l, re.I):
                self.lib_line = l.strip()
                return

    def find_lib(self):
        if self.lib_line:
            return self.lib_line
        for f in self.files:
            if f.suffix.lower() in {".spice", ".cir", ".sp", ".net"} and f.stat().st_size < 5e6:
                try:
                    self.grab_lib(f.read_text(errors="replace"))
                except OSError:
                    pass
                if self.lib_line:
                    return self.lib_line
        roots = [os.environ.get("PDK_ROOT", ""), str(Path.home() / ".volare"), "/usr/local/share/pdk",
                 "/usr/share/pdk", str(Path.home() / "pdk"), "/foss/pdks"]
        for r in roots:
            if not r:
                continue
            for p in Path(r).glob("**/sky130A/libs.tech/ngspice/sky130.lib.spice"):
                self.lib_line = f".lib {p} tt"
                return self.lib_line
        return None


# =============================================================================
# Figures
# =============================================================================
def fig_sar_conversion(P, key, name, box, nbits, show_bits=True):
    S = Signals(tran_plot(P.raw(key)), key)
    a, b, tf, vin = pick_conversion(S, CONFIG["vin_target"][key])
    scale, unit = time_unit(b - a)
    vx, vr = S.find("vx", True), S.find("vr")
    bits = list(range(nbits - 1, -1, -1))
    code = code_at(S, bits, b - 0.02 * (b - a))
    fig = plt.figure(figsize=box)
    hr = [1.4, 3.2, 0.8] + ([0.55 * nbits] if show_bits else [])
    gs = fig.add_gridspec(len(hr), 1, height_ratios=hr, hspace=0.12)
    ax0 = fig.add_subplot(gs[0])
    logic_axis(ax0, S, ["smp", "clk"], ["SMP", "CLK"], a, b, scale, {"SMP": RUST, "CLK": NAVY})
    ax1 = fig.add_subplot(gs[1], sharex=ax0)
    tt, yy = window(S, vx, a, b)
    ax1.plot((tt - a) * scale, yy, color=BLUE, lw=1.4, label="VX")
    if vr is not None:
        tt, yy = window(S, vr, a, b)
        ax1.plot((tt - a) * scale, yy, color=RUST, lw=1.2, label="VR")
    ax1.set_ylabel("V")
    ax1.legend(loc="best", frameon=False, ncol=2)
    ax0.set_title(f"VIN = {vin:.3f} V  →  code {code}" + (f" = {int(code, 2)}" if "?" not in code else ""),
                  color=NAVY, loc="left", fontweight="bold")
    ax2 = fig.add_subplot(gs[2], sharex=ax0)
    logic_axis(ax2, S, ["com"], ["COM"], a, b, scale, {"COM": GREEN})
    if show_bits:
        ax3 = fig.add_subplot(gs[3], sharex=ax0)
        logic_axis(ax3, S, [f"d{k}" for k in bits], [f"D{k}" for k in bits], a, b, scale)
        last = ax3
    else:
        last = ax2
    for ax in fig.axes[:-1]:
        plt.setp(ax.get_xticklabels(), visible=False)
    last.set_xlabel(f"time from start of sampling ({unit})")
    save(fig, P.out, name)
    log(f"  {key}: VIN {vin:.4f} V -> {code}; vectors {S.used}")
    return S, (a, b)


def fig_slide05(P):
    fig_sar_conversion(P, "sar6", "slide05_sar6_conversion.png", BOX["s05"], 6)


def fig_slide12(P):
    try:
        fig_sar_conversion(P, "sar3_v3", "slide12_v3_sar3_timing.png", BOX["s12"], 3, show_bits=False)
    except Exception as e:
        log(f"  v3 timing failed: {e}")
    S = Signals(tran_plot(P.raw("sar3_old")), "sar3_old")
    a, b, tf, vin = pick_conversion(S, CONFIG["vin_target"]["sar3_old"])
    scale, unit = time_unit(b - a)
    code = code_at(S, [2, 1, 0], b - 0.02 * (b - a))
    fig = plt.figure(figsize=BOX["s12"])
    gs = fig.add_gridspec(2, 1, height_ratios=[1.3, 3], hspace=0.12)
    ax0 = fig.add_subplot(gs[0])
    logic_axis(ax0, S, ["smp", "clk"], ["S/H", "CLK"], a, b, scale, {"S/H": RUST})
    ax1 = fig.add_subplot(gs[1], sharex=ax0)
    vin_v, ref = S.find("vin"), S.find("ref", True)
    if vin_v is not None:
        tt, yy = window(S, vin_v, a, b)
        ax1.plot((tt - a) * scale, yy, color=BLUE, lw=1.4, label="VIN")
    tt, yy = window(S, ref, a, b)
    ax1.plot((tt - a) * scale, yy, color=RUST, lw=1.2, label="REF")
    ax1.set_ylabel("V")
    ax1.legend(loc="best", frameon=False, ncol=2)
    ax0.set_title(f"old SAR · VIN = {vin:.3f} V  →  code {code}", color=NAVY, loc="left", fontweight="bold")
    plt.setp(ax0.get_xticklabels(), visible=False)
    ax1.set_xlabel(f"time ({unit})")
    save(fig, P.out, "slide12_old_sar3_timing.png")
    log(f"  sar3_old vectors {S.used}")


def fig_slide14(P):
    S = Signals(tran_plot(P.raw("sar6")), "sar6")
    a, b, tf, vin = pick_conversion(S, CONFIG["vin_target"]["sar6"])
    vx, vr, clk = S.find("vx", True), S.find("vr", True), S.find("clk", True)
    rises = edges(S.t, clk, CONFIG["vdd"] / 2)
    rises = rises[(rises > tf) & (rises < b)]
    if not len(rises):
        raise RuntimeError("no CLK rising edge inside the conversion")
    te = rises[-1]  # last decision: smallest VX-VR, kick most visible
    lo, hi = te - 0.6e-9, te + 1.6e-9
    m = (S.t >= lo) & (S.t <= hi)
    t = (S.t[m] - te) * 1e9
    vx0, vr0 = val_at(S.t, vx, te - 0.1e-9), val_at(S.t, vr, te - 0.1e-9)
    dx, dr = (vx[m] - vx0) * 1e3, (vr[m] - vr0) * 1e3
    fig = plt.figure(figsize=BOX["s14"])
    gs = fig.add_gridspec(1, 2, width_ratios=[1, 1], wspace=0.28)
    ax = fig.add_subplot(gs[0])
    ax.plot(t, dx, color=BLUE, lw=1.3, label="VX")
    ax.plot(t, dr, color=RUST, lw=1.1, ls="--", label="VR")
    ax.set_ylabel("change (mV)")
    ax.set_xlabel("time from CLK edge (ns)")
    ax.legend(frameon=False, loc="upper right", ncol=2)
    ax.set_title(f"each input kicks {np.max(np.abs(dx)):.0f} / {np.max(np.abs(dr)):.0f} mV", color=NAVY, loc="left")
    ax2 = fig.add_subplot(gs[1])
    dd = dx - dr
    ax2.plot(t, dd, color=GREEN, lw=1.3)
    ax2.set_ylabel("VX − VR change (mV)")
    ax2.set_xlabel("time from CLK edge (ns)")
    lsb = CONFIG["vref"] / 64 * 1e3
    ax2.axhspan(-lsb / 2, lsb / 2, color=GRID, zorder=0)
    ax2.set_title(f"difference moves {np.max(np.abs(dd)):.1f} mV (½ LSB band shaded)", color=NAVY, loc="left")
    save(fig, P.out, "slide14_kickback_zoom.png")
    log(f"  kick: VX {np.max(np.abs(dx)):.1f} mV, VR {np.max(np.abs(dr)):.1f} mV, diff {np.max(np.abs(dd)):.2f} mV")


def fig_slide17(P):
    # v3: the 7 timing inputs
    try:
        S = Signals(tran_plot(P.raw("sar3_v3")), "sar3_v3")
        a, b, tf, vin = pick_conversion(S, CONFIG["vin_target"]["sar3_v3"])
        scale, unit = time_unit(b - a)
        fig, ax = plt.subplots(figsize=BOX["s17"])
        roles = ["smp", "clk", "c2", "u2", "c1", "u1", "c0"]
        logic_axis(ax, S, roles, [r.upper() for r in roles], a, b, scale,
                   {"SMP": RUST, "CLK": BLUE})
        code = code_at(S, [2, 1, 0], b - 0.02 * (b - a))
        ax.set_title(f"v3: 7 timing inputs from outside · VIN = {vin:.2f} V → {code} · {(b - a) * scale:.1f} {unit} shown",
                     color=NAVY, loc="left")
        ax.set_xlabel(f"time ({unit})")
        save(fig, P.out, "slide17_v3_timing.png")
    except Exception as e:
        log(f"  v3 timing (slide 17) failed: {e}")
    # async
    S = Signals(tran_plot(P.raw("sar3_async")), "sar3_async")
    a, b, tf, vin = pick_conversion(S, CONFIG["vin_target"]["sar3_async"])
    eoc = S.find("eoc")
    t_end = b
    t_eoc = None
    if eoc is not None:
        r = edges(S.t, eoc, CONFIG["vdd"] / 2)
        r = r[r > tf]
        if len(r):
            t_eoc = r[0]
            t_end = min(b, t_eoc + 0.35 * (t_eoc - tf) + 0.5e-9)
    a2 = max(a, tf - 0.25 * (t_end - tf))
    scale, unit = time_unit(t_end - a2)
    fig = plt.figure(figsize=BOX["s17a"])
    gs = fig.add_gridspec(2, 1, height_ratios=[1.5, 4], hspace=0.1)
    ax1 = fig.add_subplot(gs[0])
    vx, vr = S.find("vx"), S.find("vr")
    for y, col, lab in ((vx, BLUE, "VX"), (vr, RUST, "VR")):
        if y is not None:
            tt, yy = window(S, y, a2, t_end)
            ax1.plot((tt - a2) * scale, yy, color=col, lw=1.2, label=lab)
    ax1.legend(frameon=False, loc="upper right", ncol=2)
    ax1.set_ylabel("V")
    ax2 = fig.add_subplot(gs[1], sharex=ax1)
    roles = ["smp", "clk", "valid", "act2", "act1", "act0", "d2", "d1", "d0", "eoc"]
    labs = ["SMP", "CLK", "VALID", "ACT2", "ACT1", "ACT0", "D2", "D1", "D0", "EOC"]
    logic_axis(ax2, S, roles, labs, a2, t_end, scale, {"SMP": RUST, "CLK": BLUE, "VALID": GREEN, "EOC": RUST})
    plt.setp(ax1.get_xticklabels(), visible=False)
    ax2.set_xlabel(f"time ({unit})")
    code = code_at(S, [2, 1, 0], t_end)
    txt = f"async: only SMP from outside · VIN = {vin:.2f} V → {code}"
    if t_eoc is not None:
        txt += f" · SMP falls → EOC in {(t_eoc - tf) * 1e9:.2f} ns"
        for ax in (ax1, ax2):
            ax.axvspan((tf - a2) * scale, (t_eoc - a2) * scale, color="#E6EEF9", zorder=0)
    ax1.set_title(txt, color=NAVY, loc="left")
    save(fig, P.out, "slide17_async3_timing.png")
    log(f"  async vectors {S.used}")
    if t_eoc is not None:
        log(f"  async: SMP fall -> EOC = {(t_eoc - tf) * 1e9:.2f} ns (deck says 3.9 ns)")


# ---------------- slide 6: MIM capacitance ----------------
def fig_slide06(P):
    lib = P.find_lib()
    if not lib:
        raise RuntimeError("no sky130 .lib line found (set PDK_ROOT or keep one netlist in the folder)")
    sizes = CONFIG["mim_sizes"]
    f = 1e6
    lines = ["* MIM unit capacitance vs size", lib]
    for i, s in enumerate(sizes):
        lines.append(f"V{i} t{i} 0 dc 0 ac 1")
        lines.append(f"XC{i} t{i} 0 sky130_fd_pr__cap_mim_m3_1 W={s} L={s} MF=1")
    lines += [f".ac lin 1 {f} {f}", ".control", "run"]
    for i in range(len(sizes)):
        lines.append(f"let cap{i} = mag(i(v{i}))/(2*pi*{f})")
        lines.append(f"print cap{i}")
    lines += [".endc", ".end"]
    netp = P.work / "mim_sizes.spice"
    netp.write_text("\n".join(lines) + "\n")
    rc, msg = run(["ngspice", "-b", str(netp)], cwd=P.work, timeout=300)
    (P.work / "mim_ngspice.log").write_text(msg)
    caps = {}
    for m in re.finditer(r"^\s*cap(\d+)\s*=\s*([-+0-9.eE]+)", msg, re.M):
        caps[int(m.group(1))] = float(m.group(2))
    if len(caps) < 3:
        raise RuntimeError(f"could not measure MIM caps (rc {rc}); see _work/mim_ngspice.log")
    W = np.array([sizes[i] for i in sorted(caps)])
    C = np.array([caps[i] for i in sorted(caps)]) * 1e15  # fF
    A, Pm = W * W, 4 * W
    M = np.vstack([A, Pm]).T
    (ca, cp), *_ = np.linalg.lstsq(M, C, rcond=None)
    log(f"  MIM fit: area {ca:.3f} fF/um^2, perimeter {cp:.4f} fF/um")
    with open(P.out / "slide06_mim_values.csv", "w") as fh:
        fh.write("side_um,C_fF,area_part_fF,perimeter_part_fF,sigma_percent\n")
        for w, c in zip(W, C):
            fh.write(f"{w},{c:.3f},{ca * w * w:.3f},{cp * 4 * w:.3f},{2.8 / w:.3f}\n")
    show = [s for s in CONFIG["mim_show"] if s in list(W)]
    fig, ax = plt.subplots(figsize=BOX["s06"])
    y = np.arange(len(show))[::-1]
    for yi, s in zip(y, show):
        ar, pe = ca * s * s, cp * 4 * s
        tot = float(C[list(W).index(s)])
        ax.barh(yi, ar, color=BLUE, height=0.62)
        ax.barh(yi, pe, left=ar, color=RUST, height=0.62)
        ax.text(ar + pe + 2, yi, f"{tot:.1f} fF   perimeter {100 * pe / (ar + pe):.0f}%   "
                f"mismatch σ {2.8 / s:.1f}%", va="center", fontsize=7, color=NAVY)
    ax.set_yticks(y)
    ax.set_yticklabels([f"{s:g}×{s:g} µm" for s in show], color=NAVY)
    ax.set_xlabel("unit capacitance (fF)")
    ax.set_xlim(0, max(C[list(W).index(s)] for s in show) * 1.6)
    ax.grid(axis="y", visible=False)
    ax.legend(["area part", "perimeter part"], frameon=False, loc="lower right", ncol=2,
              bbox_to_anchor=(1.0, 1.0))
    ax.set_title(f"sky130 cap_mim_m3_1 (ngspice, PDK model): {ca:.2f} fF/µm² area + {cp:.3f} fF/µm perimeter",
                 color=NAVY, loc="left")
    save(fig, P.out, "slide06_mim_capacitance.png")


# ---------------- slide 10: latch cases ----------------
def parse_subckts(text):
    subs, cur = {}, None
    lines = text.splitlines()
    # join continuation lines
    joined = []
    for l in lines:
        if l.startswith("+") and joined:
            joined[-1] += " " + l[1:]
        else:
            joined.append(l)
    for l in joined:
        s = l.strip()
        if re.match(r"^\.subckt\s", s, re.I):
            toks = s.split()
            name = toks[1].lower()
            pins = [t for t in toks[2:] if "=" not in t]
            cur = {"name": name, "pins": pins, "lines": [l]}
        elif cur is not None:
            cur["lines"].append(l)
            if re.match(r"^\.ends", s, re.I):
                subs[cur["name"]] = cur
                cur = None
    return subs, joined


PIN_ROLES = [
    ("gnd", r"^(gnd|vss|vgnd|agnd|0|vnb)$"),
    ("vdd", r"^(vdd|vcc|vpwr|avdd|vdda|vccd|vpb)$"),
    ("clkb", r"^(clkb|clk_b|clkn|nclk|clkbar)$"),
    ("clk", r"^(clk|ck|clk_in|clkc|clk_comp)$"),
    ("inp", r"^(inp|vinp|in_p|inplus|plus|vip|vp|ip|vin_p|vx|in1)$"),
    ("inn", r"^(inn|vinn|in_n|inminus|minus|vin_n|vn|im|vr|in2)$"),
]


def fig_slide10(P):
    src = None
    for key in ("sar3_v3", "sar6", "sar3_async"):
        try:
            net = P.netlist(key)
        except Exception:
            net = None
        if net:
            subs, joined = parse_subckts(Path(net).read_text(errors="replace"))
            names = [n for n in subs if not any(re.search(e, n) for e in CONFIG["latch_subckt_exc"])]
            for rx in CONFIG["latch_subckt"]:
                hit = [n for n in names if re.search(rx, n)]
                if hit:
                    src = (net, subs, joined, hit[0])
                    break
        if src:
            break
    if not src:
        raise RuntimeError("could not find the latch subcircuit in any SAR netlist; "
                           "set CONFIG['latch_subckt']")
    net, subs, joined, lname = src
    P.grab_lib("\n".join(joined))
    latch = subs[lname]
    log(f"  latch subckt '{lname}' pins {latch['pins']} (from {Path(net).name})")
    pinmap = []
    for p in latch["pins"]:
        pl = p.lower()
        role = CONFIG["latch_pins"].get(pl)
        if role is None:
            role = next((r for r, rx in PIN_ROLES if re.match(rx, pl)), None)
        pinmap.append((p, role))
    log(f"  pin map: {pinmap}")
    if not any(r == "inp" for _, r in pinmap) or not any(r == "inn" for _, r in pinmap) \
            or not any(r == "clk" for _, r in pinmap):
        raise RuntimeError(f"cannot tell which latch pins are INP/INN/CLK: {latch['pins']}. "
                           "Set CONFIG['latch_pins']")
    has_clkb = any(r == "clkb" for _, r in pinmap)
    header = [l for l in joined if re.match(r"^\s*\.(lib|include|inc|param|option|options|temp|model)\b", l, re.I)]
    body = []
    for s in subs.values():
        body += s["lines"]
    vdd = CONFIG["vdd"]
    period, delay = 10e-9, 2e-9
    nodes = []
    extra = []
    for p, r in pinmap:
        if r in ("vdd", "clk", "clkb", "inp", "inn"):
            nodes.append(r)
        elif r == "gnd":
            nodes.append("0")
        elif r:
            nodes.append(r)
        else:
            n = p.lower()
            nodes.append(n)
            extra.append(f"Rpull_{p} {n} 0 1G")
    results = []
    data = []
    for ci, (lab, vxv, vrv) in enumerate(CONFIG["latch_cases"]):
        rawp = (P.work / f"latch_case{ci}.raw").resolve()
        if rawp.exists():
            rawp.unlink()
        net_lines = [f"* latch case {lab}"] + header + body + [
            f"VDD vdd 0 {vdd}",
            f"VCLK clk 0 pulse(0 {vdd} {delay} 30p 30p {period / 2 - 30e-12} {period})",
        ]
        if has_clkb:
            net_lines.append(f"VCLKB clkb 0 pulse({vdd} 0 {delay} 30p 30p {period / 2 - 30e-12} {period})")
        net_lines += [f"VINP inp 0 {vxv}", f"VINN inn 0 {vrv}",
                      f"XL {' '.join(nodes)} {lname}"] + extra + [
            f".tran 2p {delay + 1.6 * period}", ".control", "run", f"write {rawp}", ".endc", ".end"]
        netp = P.work / f"latch_case{ci}.spice"
        netp.write_text("\n".join(net_lines) + "\n")
        rc, msg = run(["ngspice", "-b", str(netp)], cwd=Path(net).parent, timeout=300)
        (P.work / f"latch_case{ci}.log").write_text(msg)
        if not rawp.exists():
            raise RuntimeError(f"latch case {ci} did not simulate; see _work/latch_case{ci}.log")
        S = Signals(tran_plot(rawp), f"latch{ci}")
        clk = S.find("clk", True)
        te = edges(S.t, clk, vdd / 2)
        te = te[te > delay + period / 2][0]  # second rising edge
        x, y = S.find("x"), S.find("y")
        com = S.find("com")
        comb = S.find("comb")
        m = S.t >= te
        td = float("nan")
        if x is not None and y is not None:
            d = np.abs(x - y)
        elif com is not None and comb is not None:
            d = np.abs(com - comb)
        else:
            d = None
        if d is not None:
            idx = np.where(m & (d > vdd / 2))[0]
            if len(idx):
                td = S.t[idx[0]] - te
        result = val_at(S.t, com, te + period / 2 - 0.2e-9) > vdd / 2 if com is not None else None
        expect = vxv > vrv
        results.append((lab, vxv, vrv, (vxv - vrv) * 1e3, td * 1e9, expect, result))
        data.append((S, te, x, y, com))
        log(f"  {lab}: VX-VR {1e3 * (vxv - vrv):+.2f} mV, decision {td * 1e9:.3f} ns, "
            f"COM {'1' if result else '0' if result is not None else '?'} (expect {'1' if expect else '0'})")
    with open(P.out / "slide10_latch_decision_times.csv", "w") as fh:
        fh.write("case,VX_V,VR_V,VX-VR_mV,decision_ns,expected,COM\n")
        for r in results:
            fh.write(f"{r[0]},{r[1]},{r[2]},{r[3]:+.2f},{r[4]:.3f},{int(r[5])},"
                     f"{'' if r[6] is None else int(r[6])}\n")
    fig, axes = plt.subplots(1, len(data), figsize=BOX["s10"], sharey=True)
    for ax, (S, te, x, y, com), r in zip(axes, data, results):
        lo, hi = te - 0.4e-9, te + 3.5e-9
        mm = (S.t >= lo) & (S.t <= hi)
        tt = (S.t[mm] - te) * 1e9
        ax.plot(tt, S.find("clk")[mm], color="#B8BEC6", lw=0.9, label="CLK")
        if x is not None:
            ax.plot(tt, x[mm], color=BLUE, lw=1.2, label="X")
        if y is not None:
            ax.plot(tt, y[mm], color=RUST, lw=1.2, label="Y")
        if com is not None:
            ax.plot(tt, com[mm], color=GREEN, lw=1.0, ls="--", label="COM")
        if not math.isnan(r[4]):
            ax.axvline(r[4], color=NAVY, lw=0.6, ls=":")
        ok = "" if r[6] is None else (" ✓" if r[6] == r[5] else " ✗")
        ax.set_title(f"{r[0]}\nVX−VR {r[3]:+.2f} mV · {r[4]:.2f} ns{ok}", color=NAVY, fontsize=7)
        ax.set_xlabel("ns from CLK edge")
    axes[0].set_ylabel("V")
    h, l = axes[0].get_legend_handles_labels()
    fig.tight_layout(w_pad=0.6, rect=(0, 0, 1, 0.9))
    fig.legend(h, l, frameon=False, ncol=4, loc="upper right", fontsize=7)
    save(fig, P.out, "slide10_latch_cases.png")


# ---------------- schematic images ----------------
def export_schematic(P, key, name):
    sch = P.find(CONFIG["sch"][key], {".sch"})
    if not sch:
        raise RuntimeError(f"no schematic found for {key} (patterns {CONFIG['sch'][key]['inc']}); "
                           "edit CONFIG['sch'] or export it by hand")
    if not shutil.which("xschem"):
        raise RuntimeError("xschem not on PATH: export schematics by hand (File > Image export)")
    svg = (P.out / f"{name}.svg").resolve()
    png = (P.out / f"{name}.png").resolve()
    rc, msg = run(["xschem", "-q", "-x", "--svg", "--plotfile", str(svg), str(sch)], cwd=sch.parent, timeout=60)
    if not svg.exists():
        rc, msg = run(["xschem", "-q", "--svg", "--plotfile", str(svg), str(sch)], cwd=sch.parent, timeout=60)
    if svg.exists():
        log(f"  wrote {svg.name} from {sch.name}")
        for conv in (["rsvg-convert", "-z", "3", "-b", "white", "-o", str(png), str(svg)],
                     ["inkscape", str(svg), "--export-type=png", f"--export-filename={png}", "--export-dpi=300"]):
            if shutil.which(conv[0]):
                run(conv, timeout=60)
                if png.exists():
                    log(f"  wrote {png.name}")
                    break
        if not png.exists():
            try:
                import cairosvg  # noqa
                cairosvg.svg2png(url=str(svg), write_to=str(png), scale=3, background_color="white")
                log(f"  wrote {png.name}")
            except Exception:
                log("  (SVG only: insert the .svg in Slides, or install librsvg2-bin for PNG)")
    else:
        rc, msg = run(["xschem", "-q", "--png", "--plotfile", str(png), str(sch)], cwd=sch.parent, timeout=60)
        if png.exists():
            log(f"  wrote {png.name} from {sch.name}")
        else:
            raise RuntimeError(f"could not export {sch.name}: {msg.strip()[-200:]} "
                               "-> open it in xschem and use File > Image export")


def export_many(P, items):
    errs = []
    for key, name in items:
        try:
            export_schematic(P, key, name)
        except Exception as e:
            log(f"  {e}")
            errs.append(key)
    if errs:
        raise RuntimeError("not exported: " + ", ".join(errs))


def fig_slide08(P):
    export_many(P, [("old_comparator", "slide08_old_comparator"), ("latch", "slide08_latch")])


def fig_slide12_sch(P):
    export_many(P, [("sar3_old", "slide12_old_sar3_schematic"), ("sar3_v3", "slide12_v3_sar3_schematic")])


# =============================================================================
JOBS = [
    ("5", "6-bit conversion waveform", fig_slide05),
    ("6", "MIM capacitance vs unit size", fig_slide06),
    ("8", "comparator schematics", fig_slide08),
    ("10", "latch input-range cases", fig_slide10),
    ("12", "old vs v3 3-bit timing", fig_slide12),
    ("12", "3-bit SAR schematics", fig_slide12_sch),
    ("14", "kickback zoom", fig_slide14),
    ("17", "v3 and async timing", fig_slide17),
]


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("folder", nargs="?", default=".", help="ADC design folder (default: here)")
    ap.add_argument("--out", default=None, help="output folder (default: <folder>/ppt_figures)")
    ap.add_argument("--rerun", action="store_true", help="re-simulate even if .raw files exist")
    ap.add_argument("--only", default="", help="comma list of slide numbers, e.g. 10,17")
    ap.add_argument("--map", action="append", default=[], help="role=vector, e.g. vx=x1.top")
    args = ap.parse_args()
    root = Path(args.folder).expanduser().resolve()
    out = Path(args.out).expanduser().resolve() if args.out else root / "ppt_figures"
    out.mkdir(parents=True, exist_ok=True)
    for m in args.map:
        k, _, v = m.partition("=")
        CONFIG["map"][k.strip().lower()] = v.strip()
    setup_style()
    log(f"make_ppt_figures  {datetime.datetime.now():%Y-%m-%d %H:%M}")
    log(f"folder {root}\noutput {out}")
    for tool in ("ngspice", "xschem", "rsvg-convert"):
        log(f"  {tool}: {shutil.which(tool) or 'NOT FOUND'}")
    P = Project(root, out, args.rerun)
    log(f"  scanned {len(P.files)} files")
    only = {s.strip() for s in args.only.split(",") if s.strip()}
    status = []
    for slide, what, fn in JOBS:
        if only and slide not in only:
            continue
        log(f"\n== slide {slide}: {what}")
        try:
            fn(P)
            status.append((slide, what, "OK"))
        except Exception as e:
            log(f"  FAILED: {e}")
            (P.work / f"error_slide{slide}.txt").write_text(traceback.format_exc())
            status.append((slide, what, f"FAILED: {e}"))
    # report
    rep = ["SUMMARY"] + [f"  slide {s:>2}  {w:32s} {r}" for s, w, r in status] + ["", "LOG"] + LOG
    rep += ["", "VECTORS IN EACH RAW FILE USED"]
    for f in P.used_raws + sorted(P.work.glob("latch_case0.raw")):
        try:
            names = []
            for p in read_raw(f):
                names += p["vars"]
            rep.append(f"\n{f}  ({len(names)} vectors)")
            rep.append("  " + " ".join(names[:600]))
        except Exception as e:
            rep.append(f"\n{f}: unreadable ({e})")
    (out / "REPORT.txt").write_text("\n".join(rep) + "\n")
    print("\n" + "\n".join(rep[:len(status) + 1]))
    print(f"\nDone. Send me the folder {out} (REPORT.txt + the images).")


if __name__ == "__main__":
    main()
