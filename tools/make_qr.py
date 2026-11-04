"""Generate the QR code for the FashionAIble download page.

Writes qr.svg and qr.png (1024 px, exact) into the site root.

Run from anywhere, with isolated Python:
    uv run --with segno --with pillow python -I tools/make_qr.py
"""

from pathlib import Path

import segno
from PIL import Image

URL = "https://fashionaible.github.io/fashionaible-app/"
PNG_SIZE = 1024
BORDER = 4  # quiet zone in modules (the QR spec asks for 4)
DARK = "#000000"
LIGHT = "#FFFFFF"

ROOT = Path(__file__).resolve().parent.parent


def main() -> None:
    qr = segno.make(URL, error="m")

    # SVG: vector, scales freely; the quiet zone is part of the file.
    qr.save(
        str(ROOT / "qr.svg"),
        scale=10,
        border=BORDER,
        dark=DARK,
        light=LIGHT,
        xmldecl=False,
        svgns=True,
        title="QR code for https://fashionaible.github.io/fashionaible-app/",
        svgclass=None,
        lineclass=None,
    )

    # PNG: render the modules at an integer scale, then pad to exactly PNG_SIZE.
    modules = qr.symbol_size(border=0)[0]
    scale = PNG_SIZE // (modules + 2 * BORDER)
    tmp = ROOT / "tools" / "_qr_tmp.png"
    qr.save(str(tmp), scale=scale, border=BORDER, dark=DARK, light=LIGHT)
    img = Image.open(tmp).convert("RGB")
    canvas = Image.new("RGB", (PNG_SIZE, PNG_SIZE), LIGHT)
    canvas.paste(img, ((PNG_SIZE - img.width) // 2, (PNG_SIZE - img.height) // 2))
    canvas.save(ROOT / "qr.png", optimize=True)
    tmp.unlink()

    print(f"QR version {qr.version}, {modules} modules, PNG scale {scale}px per module")
    print(f"wrote {ROOT / 'qr.svg'} and {ROOT / 'qr.png'} ({PNG_SIZE} px)")


if __name__ == "__main__":
    main()
