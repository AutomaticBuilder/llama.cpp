# llama.cpp CUDA Builds

Automated pre-built binaries of [llama.cpp](https://github.com/ggml-org/llama.cpp) with CUDA support, compiled per GPU architecture. Releases are published automatically whenever a new llama.cpp release is detected.

## Releases

Each release contains one tarball per GPU architecture, named:

```
llama.cpp-<version>-cuda-<cuda-version>-<arch>.tar.gz
```

To find the right tarball for your GPU, look up your GPU's Compute Capability at:
https://developer.nvidia.com/cuda/gpus

Then download the matching `<cc>-virtual` archive. For example, an RTX 5090 (Compute Capability 12.0) would use `120-virtual`.

## Usage

```bash
./llama-cli --help
```

The binaries are self-contained. They do require a compatible CUDA runtime to be installed on the host — the CUDA version used to build is noted in the release and in the `VERSION.txt` file inside each tarball.
