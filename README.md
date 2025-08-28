# ComfyUI Docker

A Docker container for [ComfyUI](https://github.com/comfyanonymous/ComfyUI) with GPU support and additional nodes pre-installed.

## Features

- 🐳 **Docker containerized** ComfyUI for easy deployment
- 🚀 **GPU acceleration** with CUDA 12.9 support
- 📦 **Pre-installed extensions**:
  - [VideoHelperSuite](https://github.com/Kosinkadink/ComfyUI-VideoHelperSuite) for video processing
- 🔄 **Automated builds** via GitHub Actions
- 📋 **Published to GitHub Container Registry** (ghcr.io)

## Quick Start

### Using Pre-built Image

```bash
# Pull the latest image
docker pull ghcr.io/yankeguo/comfyui:latest

# Run ComfyUI
docker run -d \
  --name comfyui \
  --gpus all \
  -p 8188:8188 \
  -v $(pwd)/models:/app/models \
  -v $(pwd)/input:/app/input \
  -v $(pwd)/output:/app/output \
  ghcr.io/yankeguo/comfyui:latest
```

### Building Locally

```bash
# Clone the repository
git clone https://github.com/yankeguo/comfyui.git
cd comfyui

# Build the image
docker build -t comfyui .

# Run the container
docker run -d \
  --name comfyui \
  --gpus all \
  -p 8188:8188 \
  -v $(pwd)/models:/app/models \
  -v $(pwd)/input:/app/input \
  -v $(pwd)/output:/app/output \
  comfyui
```

## Usage

1. **Access the Web Interface**: Open your browser and navigate to `http://localhost:8188`

2. **Volume Mounts**:
   - `/app/models` - Place your AI models here
   - `/app/input` - Input files for processing
   - `/app/output` - Generated outputs will be saved here

3. **GPU Requirements**: 
   - NVIDIA GPU with CUDA support
   - Docker with NVIDIA Container Toolkit installed

## Configuration

### Environment Variables

- `UV_PYTHON_DOWNLOADS=never` - Prevents UV from downloading Python
- `UV_TORCH_BACKEND=cu129` - Uses CUDA 12.9 backend for PyTorch

### Ports

- `8188` - ComfyUI web interface

## Development

The repository includes automated CI/CD with GitHub Actions:

- **Automatic builds** on push to main/master branches
- **Multi-tag strategy** (branch, PR, SHA, latest)
- **Published to GitHub Container Registry**
- **Build caching** for faster subsequent builds

## Pre-installed Components

- **Base**: Python 3.11 on Debian Trixie
- **ComfyUI**: Latest from official repository
- **PyTorch**: With CUDA 12.9 support
- **VideoHelperSuite**: For advanced video processing capabilities
- **System packages**: git, curl, vim, tmux, ffmpeg, and media libraries

## License

This project follows the same license as ComfyUI. Please refer to the [ComfyUI repository](https://github.com/comfyanonymous/ComfyUI) for license details.

## Contributing

Contributions are welcome! Please feel free to submit issues and pull requests.