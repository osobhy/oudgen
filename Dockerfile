FROM nvidia/cuda:12.3.2-devel-ubuntu22.04

ENV DEBIAN_FRONTEND=noninteractive \
    PYTHONUNBUFFERED=1 \
    TZ=UTC

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        python3.10 python3.10-venv python3.10-dev python3-pip \
        build-essential pkg-config cmake \
        git ffmpeg libsndfile1 sox libasound2-dev \
        zip unzip sudo wget curl aria2 git-lfs rclone ssh rsync jq \
        python3-apt \
    && rm -rf /var/lib/apt/lists/*

RUN python3 -m pip install --upgrade pip setuptools wheel && \
    python3 -m pip install --index-url https://download.pytorch.org/whl/cu121 \
        torch==2.1.0 torchvision torchaudio --extra-index-url https://pypi.org/simple

RUN git clone https://github.com/osobhy/oudgen.git /workspace/oudgen

RUN python3 -m pip install -e /workspace/oudgen \
        soundfile einops omegaconf hydra-core flash-attn==2.5.5
        
RUN cd /workspace/oudgen && python3 -m pip install -e .

ARG USERNAME=dev
ARG UID=1000
RUN adduser --disabled-password --gecos '' --uid ${UID} ${USERNAME}

RUN mkdir -p /workspace/outputs /workspace/audiocraft/dataset && \
    chown -R ${USERNAME}:${USERNAME} /workspace

USER ${USERNAME}

WORKDIR /workspace/oudgen
ENV PYTHONPATH=/workspace/oudgen \
    AUDIOCRAFT_TEAM=default \
    DORA_PACKAGE=audiocraft \
    USER=dev \
    AUDIOCRAFT_DORA_DIR=/workspace/outputs

CMD ["bash"]
