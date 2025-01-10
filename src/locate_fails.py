#!/usr/bin/env python
import argparse
import re
from pathlib import Path

import matplotlib.pyplot as plt
import numpy as np
import skimage.io
from skimage.measure import regionprops
from scipy.ndimage import center_of_mass


def get_centroid(image, label):
    return tuple(map(float, center_of_mass(image == label)))


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("detlog", help="Path to DET_log.txt")
    parser.add_argument("output", help="Path to the output directory")
    parser.add_argument("scale", type=float, help="Z scale of the images")
    args = parser.parse_args()
    gt_dict = {}
    img_dict = {}
    z_dict = {}
    p_dir = Path(args.detlog).parent
    with open(args.detlog, "r") as file:
        for line in file:
            if line == "----------Splitting Operations (Penalty=5)----------\n":
                step = "Splitting Operations"
                z_dict[step] = []
                print(step)
                pattern = r"T=(\d+)\s+Label=(\d+)"
            elif line == "----------False Negative Vertices (Penalty=10)----------\n":
                step = "False Negative Vertices"
                z_dict[step] = []
                print(step)
                pattern = r"T=(\d+)\s+GT_label=(\d+)"
            elif line == "----------False Positive Vertices (Penalty=1)----------\n":
                step = "False Positive Vertices"
                z_dict[step] = []
                print(step)
                pattern = r"T=(\d+)\s+Label=(\d+)"
            elif line.startswith("T"):
                match = re.search(pattern, line)
                if match:
                    t = int(match.group(1))
                    label = int(match.group(2))
                    if step in ("Splitting Operations", "False Positive Vertices"):
                        img = img_dict.get(
                            t,
                            skimage.io.imread(p_dir / f"mask{t:03d}.tif"),
                        )
                        img_dict[t] = img
                    elif step == "False Negative Vertices":
                        img = gt_dict.get(
                            t,
                            skimage.io.imread(
                                p_dir.parent / "01_GT" / "SEG" / f"man_seg{t:03d}.tif"
                            ),
                        )
                        gt_dict[t] = img
                    centroid = get_centroid(img, label)
                    z_dict.get(step, []).append(centroid[0] * args.scale)
                    print(f"Centroid of label {label} in T={t}: {centroid}")
    gt_zs = []
    for p_gt_img in (p_dir.parent / "01_GT" / "SEG").glob("*.tif"):
        img = skimage.io.imread(p_gt_img)
        for prop in regionprops(img):
            centroid = tuple(map(float, prop.centroid))
            gt_zs.append(prop.centroid[0] * args.scale)
    p_output = Path(args.output)
    p_output.mkdir(exist_ok=True, parents=True)
    plt.hist(gt_zs, bins=range(0, 25, 1), label="GT")
    plt.title(f"{p_output.name}\nCentroid Z distribution (GT)")
    plt.xlabel("Z (µm)")
    plt.ylabel("Count")
    plt.savefig(p_output / "gt.png")
    plt.close()
    for step, zs in z_dict.items():
        plt.hist(zs, bins=range(0, 25, 1), label=step)
        plt.title(f"{p_output.name}\nCentroid Z distribution ({step})")
        plt.xlabel("Z (µm)")
        plt.ylabel("Count")
        filename = step.lower().replace(" ", "_") + ".png"
        plt.savefig(p_output / filename)
        plt.close()

    # Overlay all histograms
    num_elements_gt_zs, bins, _ = plt.hist(
        gt_zs, bins=range(0, 25, 1), alpha=0.5, label="GT"
    )
    plt.title(f"{p_output.name}\nCentroid Z distribution")
    plt.xlabel("Z (µm)")
    plt.ylabel("Count")
    num_elements_zs_list = []
    for step, zs in z_dict.items():
        num_elements_zs, _, _ = plt.hist(
            zs, bins=range(0, 25, 1), alpha=0.5, label=step
        )
        num_elements_zs_list.append(num_elements_zs)
    plt.legend()
    plt.savefig(p_output / "overlay.png")
    plt.close()

    # Plot the relative histogram
    cmap = plt.get_cmap("tab10")
    num_elements_gt_zs = np.where(num_elements_gt_zs == 0, 1, num_elements_gt_zs)
    for i, (num_elements_zs, step) in enumerate(
        zip(num_elements_zs_list, z_dict.keys())
    ):
        relative_zs = (num_elements_zs / num_elements_gt_zs).clip(0, 1)
        plt.bar(
            bins[:-1],
            relative_zs,
            width=1,
            alpha=0.5,
            label=step,
            color=cmap(1 + i),
        )
    plt.xlabel("Z (µm)")
    plt.ylabel("Normalised Frequency")
    plt.title(f"{p_output.name}\nNormalised centroid Z distribution")
    plt.legend()
    plt.savefig(p_output / "relative.png")
    plt.close()


if __name__ == "__main__":
    main()
