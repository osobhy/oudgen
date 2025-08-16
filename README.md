# Oudgen 

My fork of AudioCraft wired for oud finetuning with Dora and a CUDA 12.3 image. This is exactly how I run it locally/remote using the Dockerfile below. You can use the same workflow to finetune MusicGen on whatever data you'd like.

# Build the Dockerfile

``docker build -t oudgen:latest .``

# Run with GPU + mounted volumes, then finetune
```
docker run --rm -it --gpus all --ipc=host \
  -v "$PWD/data":/workspace/audiocraft/dataset \
  -v "$PWD/outputs":/workspace/outputs \
  -v "$PWD/cache":/workspace/cache \
  -e AUDIOCRAFT_DORA_DIR=/workspace/outputs \
  -e AUDIOCRAFT_CACHE_DIR=/workspace/cache \
  oudgen:latest```

# finetune
dora run \
  solver=musicgen/musicgen_base_32khz \
  model/lm/model_scale=small \
  compression_model_checkpoint=//pretrained/facebook/encodec_32khz \
  continue_from=//pretrained/facebook/musicgen-small \
