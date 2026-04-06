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
# These must exist at build time or workflow validation fails with "value not in list"
RUN comfy model download \
    --url "https://huggingface.co/hr16/yolox-onnx/resolve/main/yolox_l.onnx" \
    --relative-path models/onnx \
    --filename yolox_l.onnx

RUN comfy model download \
    --url "https://huggingface.co/hr16/UnJIT-DWPose/resolve/main/dw-ll_ucoco_384_bs5.torchscript.pt" \
    --relative-path models/onnx \
    --filename dw-ll_ucoco_384_bs5.torchscript.pt

# yolov10m for face detection
RUN comfy model download \
    --url "https://huggingface.co/Bingsu/adetailer/resolve/main/yolov10m_adetailer.pt" \
    --relative-path models/onnx \
    --filename yolov10m.onnx || true

# vitpose for wholebody pose estimation
RUN comfy model download \
    --url "https://huggingface.co/Kijai/WanVideo_comfy/resolve/main/vitpose_h_wholebody_model.onnx" \
    --relative-path models/onnx \
    --filename vitpose_h_wholebody_model.onnx || true
