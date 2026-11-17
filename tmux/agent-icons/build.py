"""Build a tiny monochrome font from devicons.io SVG logos.

usage: python build_font.py <svg_dir> <out.otf>
Each glyph keeps only the listed <path> elements (by index), so
multi-color logos become one silhouette; the terminal colors it.
"""
import re
import sys
from pathlib import Path

import pathops
from fontTools.fontBuilder import FontBuilder
from fontTools.pens.t2CharStringPen import T2CharStringPen
from fontTools.pens.transformPen import TransformPen
from fontTools.svgLib.path.parser import parse_path

svg_dir, out = Path(sys.argv[1]), sys.argv[2]

# name: (file, codepoint, path indexes to keep, svg->viewBox(600) transform)
ICONS = {
    "claude": ("claude-code.svg", 0xF2000, [0], (1, 0, 0, 1, 0, 0)),
    "codex": ("codex-icon.svg", 0xF2001, [0], (100 / 3, 0, 0, 100 / 3, -100, -100)),
    "opencode": ("opencode-icon.svg", 0xF2002, [1], (1, 0, 0, 1, 0, 0)),
}

UPM, ADV = 1000, 600          # JetBrains Mono: 1000 upm, 600 advance
SIZE = 760                    # icon box in font units (overflows one cell a bit)
BOTTOM = -20                  # icon box bottom (baseline = 0)


def glyph(file, keep, svgtf):
    svg = (svg_dir / file).read_text()
    paths = re.findall(r'<path\b([^>]*)/?>', svg)
    s = SIZE / 600
    # svg (y down, 600 box) -> font units (y up), left aligned at x=0
    tf = (svgtf[0] * s, 0, 0, -svgtf[3] * s, svgtf[4] * s, (600 - svgtf[5]) * s + BOTTOM)
    result = pathops.Path()
    for i in keep:
        attrs = paths[i]
        d = re.search(r'\sd="([^"]+)"', attrs).group(1)
        p = pathops.Path()
        parse_path(d, TransformPen(p.getPen(), tf))
        if 'evenodd' in attrs:
            p.fillType = pathops.FillType.EVEN_ODD
        p.simplify()  # resolve fill rule into clean non-overlapping contours
        result = pathops.op(result, p, pathops.PathOp.UNION) if len(result) else p
    pen = T2CharStringPen(ADV, None)
    result.draw(pen)
    return pen.getCharString()


fb = FontBuilder(UPM, isTTF=False)
names = [".notdef", "space"] + list(ICONS)
fb.setupGlyphOrder(names)
fb.setupCharacterMap({0x20: "space", **{cp: n for n, (_, cp, _, _) in ICONS.items()}})
empty = T2CharStringPen(ADV, None).getCharString()
cs = {".notdef": empty, "space": T2CharStringPen(ADV, None).getCharString()}
for n, (f, _, keep, tf) in ICONS.items():
    cs[n] = glyph(f, keep, tf)
fb.setupCFF("AgentIcons-Regular", {"FullName": "AgentIcons"}, cs, {})
fb.setupHorizontalMetrics({n: (ADV, 0) for n in names})
fb.setupHorizontalHeader(ascent=1020, descent=-300)
fb.setupNameTable({"familyName": "AgentIcons", "styleName": "Regular"})
fb.setupOS2(sTypoAscender=1020, sTypoDescender=-300, usWinAscent=1020, usWinDescent=300)
fb.setupPost(isFixedPitch=1)
fb.save(out)
print("wrote", out)
