#!/usr/bin/env python3
"""Scrive una copia web di un JPEG.

Lato lungo massimo 1600 px, file sotto 300 KB. Con --og ritaglia
dal centro un JPEG 1200x630. Accanto al JPEG scrive anche un WebP,
tranne nel caso --og.
Stampa su stdout una riga JSON con width, height, jpegBytes, webpBytes, sha1.
"""

import hashlib
import io
import json
import sys
from pathlib import Path

from PIL import Image, ImageOps

MAX_BYTES = 300_000
MAX_WIDTH = 1600


def encode_jpeg(image, quality):
    buffer = io.BytesIO()
    image.save(
        buffer,
        format="JPEG",
        quality=quality,
        optimize=True,
        progressive=True,
        subsampling=2,
    )
    return buffer.getvalue()


def encode_webp(image, quality):
    buffer = io.BytesIO()
    image.save(buffer, format="WEBP", quality=quality, method=6)
    return buffer.getvalue()


def open_rgb(path):
    image = ImageOps.exif_transpose(Image.open(path))
    if image.mode != "RGB":
        image = image.convert("RGB")
    return image


def fit_width(image, width):
    current_width, current_height = image.size
    if current_width <= width:
        return image
    height = max(1, round(current_height * width / current_width))
    return image.resize((width, height), Image.Resampling.LANCZOS)


def jpeg_under_budget(image):
    widths = []
    current = image.size[0]
    for width in (MAX_WIDTH, 1500, 1400, 1280, 1200, 1000):
        if width < current or width == MAX_WIDTH:
            widths.append(min(width, current))
    seen = []
    for width in widths:
        if width in seen:
            continue
        seen.append(width)
    smallest = None
    for width in seen:
        sized = fit_width(image, width)
        for quality in range(86, 59, -2):
            data = encode_jpeg(sized, quality)
            if smallest is None or len(data) < len(smallest[1]):
                smallest = (sized, data, quality)
            if len(data) <= MAX_BYTES:
                return sized, data
    return smallest[0], smallest[1]


def crop_og(image):
    width, height = image.size
    target = 1200 / 630
    if width / height > target:
        crop_width = round(height * target)
        left = (width - crop_width) // 2
        cropped = image.crop((left, 0, left + crop_width, height))
    else:
        crop_height = round(width / target)
        top = (height - crop_height) // 2
        cropped = image.crop((0, top, width, top + crop_height))
    return cropped.resize((1200, 630), Image.Resampling.LANCZOS)


def main():
    args = sys.argv[1:]
    og = "--og" in args
    args = [arg for arg in args if arg != "--og"]
    if len(args) != 2:
        print("uso: resize-web-image.py INPUT OUTPUT.jpg [--og]", file=sys.stderr)
        return 1
    source = open_rgb(args[0])
    image = crop_og(source) if og else source
    sized, jpeg = jpeg_under_budget(image) if not og else (image, None)
    if og:
        sized = image
        jpeg = encode_jpeg(sized, 82)
        if len(jpeg) > MAX_BYTES:
            for quality in range(78, 59, -2):
                jpeg = encode_jpeg(sized, quality)
                if len(jpeg) <= MAX_BYTES:
                    break
    dest = Path(args[1])
    dest.parent.mkdir(parents=True, exist_ok=True)
    dest.write_bytes(jpeg)
    webp_bytes = 0
    if not og:
        webp = encode_webp(sized, 78)
        if len(webp) > MAX_BYTES:
            for quality in (72, 66, 60):
                webp = encode_webp(sized, quality)
                if len(webp) <= MAX_BYTES:
                    break
        webp_path = dest.with_suffix(".webp")
        webp_path.write_bytes(webp)
        webp_bytes = len(webp)
    payload = {
        "width": sized.size[0],
        "height": sized.size[1],
        "jpegBytes": len(jpeg),
        "webpBytes": webp_bytes,
        "sha1": hashlib.sha1(jpeg).hexdigest(),
    }
    print(json.dumps(payload))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
