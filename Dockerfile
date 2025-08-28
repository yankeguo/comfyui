FROM python:3.11-slim

# Set environment variables
ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PIP_NO_CACHE_DIR=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1

# Install system dependencies and clone/install everything in a single RUN
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    git \
    curl \
    tini \
    ffmpeg \
    libsm6 \
    libxext6 \
    libglib2.0-0 \
    libxrender1 \
    libgomp1 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Clone ComfyUI and custom nodes, then install all dependencies in a single RUN
RUN git clone --depth=1 https://github.com/comfyanonymous/ComfyUI.git . && \
    git clone --depth=1 https://github.com/Kosinkadink/ComfyUI-VideoHelperSuite.git custom_nodes/VideoHelperSuite && \
    pip install --no-cache-dir torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu129 && \
    pip install --no-cache-dir -r requirements.txt && \
    pip install --no-cache-dir -r custom_nodes/VideoHelperSuite/requirements.txt

# Expose port
EXPOSE 8188

# Add health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
    CMD curl -f http://localhost:8188/ || exit 1

# Use tini as entrypoint for proper signal handling
ENTRYPOINT ["/usr/bin/tini", "--"]

# Default command
CMD ["python3", "server.py", "--listen", "0.0.0.0", "--port", "8188"]
