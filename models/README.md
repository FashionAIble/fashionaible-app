# Cut-out model

The app removes the background from clothing photos on the phone. It uses **BiRefNet-lite** (MIT licence, see [BiRefNet-LICENSE.txt](BiRefNet-LICENSE.txt)), exported by the team at a fixed 768 px input size.

- **Release:** [`cutout-model-v1`](https://github.com/FashionAIble/fashionaible-app/releases/tag/cutout-model-v1)
- **Asset:** `cutout-model.onnx` (about 183.8 MB)
- **SHA-256:** `7296b8c02adca56e9488d8fa3fc2db86ca335e46430c62ae0b194da15ba7d29a`
- **Direct link:** https://github.com/FashionAIble/fashionaible-app/releases/download/cutout-model-v1/cutout-model.onnx

The app downloads the model once. Only the model comes down; no photo is sent.

Check a download with:

    sha256sum cutout-model.onnx

The hash must match the value above.

Licence: the model is MIT (copyright 2024 ZhengPeng, the original BiRefNet authors). The licence text is included unchanged.
