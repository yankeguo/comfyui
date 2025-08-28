FROM ghcr.io/astral-sh/uv:0.8.13-python3.11-trixie

# Set environment variables
ENV UV_PYTHON_DOWNLOADS=never \
    UV_TORCH_BACKEND=cu129 \
    PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1

# Install system dependencies in a single layer
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    git \
    curl \
    vim \
    tmux \
    tini \
    ffmpeg \
    libsm6 \
    libxext6 \
    libglib2.0-0 \
    libxrender1 \
    libgomp1 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Set working directory early
WORKDIR /app

# Clone repositories and install dependencies in optimized order
RUN git clone --depth=1 https://github.com/comfyanonymous/ComfyUI.git . && \
    cd custom_nodes && \
    git clone --depth=1 https://github.com/Kosinkadink/ComfyUI-VideoHelperSuite.git VideoHelperSuite && \
    cd .. && \
    uv venv /venv && \
    source /venv/bin/activate && \
    uv pip install torch torchvision torchaudio && \
    uv pip install -r requirements.txt && \
    uv pip install -r custom_nodes/VideoHelperSuite/requirements.txt

# Create non-root user for security
RUN groupadd -r comfyui && useradd -r -g comfyui -d /app -s /bin/bash comfyui && \
    chown -R comfyui:comfyui /app

# Switch to non-root user
USER comfyui

# Expose port
EXPOSE 8188

# Add health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
    CMD curl -f http://localhost:8188/ || exit 1

# Use tini as entrypoint for proper signal handling
ENTRYPOINT ["/usr/bin/tini", "--"]

# Default command
CMD ["/venv/bin/python3", "server.py", "--listen", "0.0.0.0", "--port", "8188"]
