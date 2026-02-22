# -*- coding: utf-8 -*-
import logging
import re
from pathlib import Path

from PIL import Image

logger = logging.getLogger(__name__)

IOS_ICON_PATH = "proj.ios_mac/ios/Images.xcassets/AppIcon.appiconset"
IOS_ICONS = [
    "Icon-29.png",
    "Icon-76@2x.png",
    "Icon-40@2x.png",
    "Icon-40@3x.png",
    "Icon-50@2x.png",
    "Icon-83.5@2x.png",
    "Icon-60@3x.png",
    "Icon-29@2x.png",
    "Icon-76.png",
    "Icon-72.png",
    "Icon-72@2x.png",
    "Icon-29@3x.png",
    "Icon-60@2x.png",
    "Icon-20@3x.png",
    "Icon-57.png",
    "Icon-40.png",
    "Icon-50.png",
    "Icon-20@2x.png",
    "Icon-20.png",
    "Icon-57@2x.png",
]

MAC_ICON_PATH = "proj.ios_mac/mac/Icon.icns"


def parse_icon_size(filename: str) -> int:
    match = re.search(r"Icon-([\d.]+)(?:@(\d)x)?\.png", filename)
    if not match:
        raise ValueError(f"Cannot parse icon size from {filename}")

    base_size = float(match.group(1))
    scale = int(match.group(2)) if match.group(2) else 1
    return int(base_size * scale)


def gen_ios_png_icon(source_path: str, output_dir: str = "."):
    source = Path(source_path)
    if not source.exists():
        raise FileNotFoundError(f"Source image not found: {source_path}")

    with Image.open(source_path) as img:
        if img.mode != "RGBA":
            img = img.convert("RGBA")

        for icon_name in IOS_ICONS:
            size = parse_icon_size(icon_name)
            output_path = Path(output_dir) / icon_name
            output_path.parent.mkdir(parents=True, exist_ok=True)

            resized = img.resize((size, size), Image.Resampling.LANCZOS)
            resized.save(output_path, "PNG")
            logger.info(f"Generated: {icon_name} ({size}x{size})")


def gen_mac_icns_icon(source_path: str, output_file: str):
    source = Path(source_path)
    if not source.exists():
        raise FileNotFoundError(f"Source image not found: {source_path}")

    # 生成 ICNS 文件
    output_path = Path(output_file)
    output_path.parent.mkdir(parents=True, exist_ok=True)

    with Image.open(source_path) as img:
        if img.mode != "RGBA":
            img = img.convert("RGBA")

        img.save(output_path, "ICNS")
        logger.info(f"Generated: {output_file}")


def gen_cocos_icon_files(source_path: str):
    gen_ios_png_icon(source_path, output_dir=IOS_ICON_PATH)
    gen_mac_icns_icon(source_path, output_file=MAC_ICON_PATH)
