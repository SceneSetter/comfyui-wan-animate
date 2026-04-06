FROM runpod/worker-comfyui:5.8.5-base

# Install custom nodes required for WAN Video Animate character replacement
RUN comfy-node-install \
    ComfyUI-WanVideoWrapper \
    ComfyUI-segment-anything-2 \
    comfyui-kjnodes \
    ComfyUI-VideoHelperSuite \
    comfyui_controlnet_aux
