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

# SetNode/GetNode used for data routing in the workflow
RUN cd /comfyui/custom_nodes && \
    git clone https://github.com/chrisgoringe/cg-use-everywhere.git

# Download required ONNX models for pose detection
RUN mkdir -p /comfyui/models/onnx && \
    curl -L -o /comfyui/models/onnx/yolov10m.onnx \
      "https://huggingface.co/Bingsu/adetailer/resolve/main/yolov10m.pt" || \
    curl -L -o /comfyui/models/onnx/yolov10m.onnx \
      "https://github.com/akanametov/yolo-face/releases/download/v0.0.0/yolov10m.onnx" || true

RUN curl -L -o /comfyui/models/onnx/vitpose_h_wholebody_model.onnx \
      "https://huggingface.co/nicehuster/vitpose_wholebody/resolve/main/vitpose-h-wholebody.onnx" || true
