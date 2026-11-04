# FashionAIble app site

Public download page for the FashionAIble Android app: <https://fashionaible.github.io/fashionaible-app/>

- This repository only holds the static page, the QR code and the releases.
- **The source code is private** and is not in this repository.
- No frameworks, no scripts, no external fonts or CDNs, no tracking.

## Files

| Path | What it is |
|---|---|
| `index.html`, `style.css` | Download page (English first, German below) |
| `presentation/` | The final presentation (generated, do not edit; see below) |
| `tools/update-presentation.sh` | Rebuilds the presentation from the private repository and copies it here |
| `imprint.html` | Impressum and legal notice, copied from the app's `IMPRINT.md` |
| `qr.svg`, `qr.png` | QR code for the page (`qr.png` is 1024 px) |
| `qr-poster.html` | Printable A4 poster: QR and "Scan to get FashionAIble" |
| `models/README.md`, `models/BiRefNet-LICENSE.txt` | Cut-out model description and its MIT licence |
| `tools/make_qr.py` | Generates `qr.svg` and `qr.png` |
| `LICENSE.md` | Licence notes |

## Regenerate the QR code

    uv run --with segno --with pillow python -I tools/make_qr.py

## Publish a new app version

1. Build the release APK in the private repository (Release APK workflow) and download it.
2. Rename it to exactly `fashionaible.apk`. The download link depends on that name.
3. Create the release here, with the APK as the only asset:

        gh release create v1.2.3 fashionaible.apk --repo FashionAIble/fashionaible-app --title "v1.2.3" --notes "..."

   It becomes the "latest" release automatically, so the link `releases/latest/download/fashionaible.apk` points to it.

## Publish the cut-out model (only when it changes)

The model is a separate release, `cutout-model-v1`. It must **not** become the "latest" release, or the APK link would break.

1. Take the 768 px export (`birefnet-lite-768.onnx`, SHA-256 `7296b8c0…d29a`, 183,843,087 bytes), rename it to `cutout-model.onnx`.
2. Create the release with `--latest=false`:

        gh release create cutout-model-v1 cutout-model.onnx --repo FashionAIble/fashionaible-app --latest=false --title "Cut-out model v1" --notes "BiRefNet-lite 768 px, MIT. See models/README.md."

3. Check the SHA-256 of the downloaded asset against `models/README.md`.

## GitHub Pages settings

Settings → Pages:

- Source: **Deploy from a branch**
- Branch: `main`, folder: **/ (root)**

The repository has to be **public** for Pages on the GitHub Free plan. The `.nojekyll` file stops Jekyll from processing the files.

## Checks before publishing

- Open `index.html` and check both language sections and both links (APK and imprint).
- Scan `qr.png` with a phone and check that it opens the page.
- Confirm that the APK link downloads `fashionaible.apk` from the latest release.

## Update the presentation

`presentation/index.html` is the master deck of the private repository (`docs/presentation/master/`), rebuilt from the chapters on `main`; the demo videos go to `presentation/media/`. Run this before the final presentation, so the site shows the latest state:

    tools/update-presentation.sh            # rebuild and copy, check presentation/index.html locally
    tools/update-presentation.sh --publish  # the same, then commit and push (live after about a minute)

It needs a clone of the private repository (default `~/fashionAIble-master`, or pass the path as the last argument) and Python 3.9+ (`uv` is used if installed). It does not touch the branch or files of that clone. Videos that are not in the repository yet are listed as missing; their slides show the placeholder.

Claude Code can do it for you: *"Update the presentation on the app site and publish it."*
