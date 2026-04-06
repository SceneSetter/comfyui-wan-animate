FROM runpod/worker-comfyui:5.8.5-base

# Install custom nodes via comfy-node-install
RUN comfy-node-install \
    ComfyUI-WanVideoWrapper \
    ComfyUI-WanAnimatePreprocess \
    comfyui-kjnodes \
    comfyui_controlnet_aux

# Manually install nodes that comfy-node-install silently skips
RUN cd /comfyui/custom_nodes && \
    git clone https://github.com/kijai/ComfyUI-segment-anything-2.git && \
    cd ComfyUI-segment-anything-2 && \
    /opt/venv/bin/pip install -r requirements.txt || true

RUN cd /comfyui/custom_nodes && \
    git clone https://github.com/Kosinkadink/ComfyUI-VideoHelperSuite.git && \
    cd ComfyUI-VideoHelperSuite && \
    /opt/venv/bin/pip install -r requirements.txt || true

# SetNode/GetNode virtual node support
RUN cd /comfyui/custom_nodes && \
    git clone https://github.com/chrisgoringe/cg-use-everywhere.git

# Download ONNX models for WanAnimatePreprocess pose detection
# Use direct curl with || true so build doesn't fail if a URL is wrong
RUN mkdir -p /comfyui/models/onnx && \
    curl -L -o /comfyui/models/onnx/yolox_l.onnx \
      "https://huggingface.co/hr16/yolox-onnx/resolve/main/yolox_l.onnx" && \
    curl -L -o /comfyui/models/onnx/vitpose_h_wholebody_model.onnx \
      "https://huggingface.co/Kijai/WanVideo_comfy/resolve/main/vitpose_h_wholebody_model.onnx" || true

# yolov10m - try multiple sources
RUN curl -L -o /comfyui/models/onnx/yolov10m.onnx \
      "https://huggingface.co/Kijai/WanVideo_comfy/resolve/main/yolov10m.onnx" || \
    curl -L -o /comfyui/models/onnx/yolov10m.onnx \
      "https://github.com/THU-MIG/yolov10/releases/download/v1.1/yolov10m.pt" || true

# dw-ll_ucoco pose model
RUN curl -L -o /comfyui/models/onnx/dw-ll_ucoco_384_bs5.torchscript.pt \
      "https://huggingface.co/Kijai/WanVideo_comfy/resolve/main/dw-ll_ucoco_384_bs5.torchscript.pt" || \
    curl -L -o /comfyui/models/onnx/dw-ll_ucoco_384_bs5.torchscript.pt \
      "https://huggingface.co/yzd-v/DWPose/resolve/main/dw-ll_ucoco_384_bs5.torchscript.pt" || true
