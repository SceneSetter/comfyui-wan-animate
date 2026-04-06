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
