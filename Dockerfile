FROM nvidia/cuda:12.3.2-devel-ubuntu22.04

ENV DEBIAN_FRONTEND=noninteractive \
    PYTHONUNBUFFERED=1 \
    TZ=UTC

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        python3.10 python3.10-venv python3.10-dev python3-pip \
        build-essential pkg-config cmake \
        git ffmpeg libsndfile1 sox libasound2-dev \
    && rm -rf /var/lib/apt/lists/*

RUN python3 -m pip install --upgrade pip setuptools wheel && \
    python3 -m pip install --index-url https://download.pytorch.org/whl/cu121 \
        torch==2.1.0 torchvision torchaudio --extra-index-url https://pypi.org/simple

RUN python3 -m pip install --no-cache-dir \
        git+https://github.com/facebookresearch/audiocraft#egg=audiocraft \
        soundfile einops omegaconf hydra-core flash-attn==2.5.5

ARG USERNAME=dev
ARG UID=1000
RUN adduser --disabled-password --gecos '' --uid ${UID} ${USERNAME}
USER ${USERNAME}


WORKDIR /workspace
ENV PYTHONPATH=/workspace \
    AUDIOCRAFT_TEAM=default

CMD ["bash"]
