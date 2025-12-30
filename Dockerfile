# Stage 1: Install ffmpeg in Debian (for better compatibility)
FROM debian:bookworm-slim AS ffmpeg-stage
RUN apt-get update && \
    apt-get install -y --no-install-recommends ffmpeg && \
    rm -rf /var/lib/apt/lists/*

# Stage 2: Copy ffmpeg to n8n image
FROM docker.n8n.io/n8nio/n8n

USER root
# Ensure library directory exists
RUN mkdir -p /usr/lib/x86_64-linux-gnu
# Copy ffmpeg binaries from Debian stage
COPY --from=ffmpeg-stage /usr/bin/ffmpeg /usr/bin/ffmpeg
COPY --from=ffmpeg-stage /usr/bin/ffprobe /usr/bin/ffprobe
# Copy ffmpeg libraries from standard Debian location
COPY --from=ffmpeg-stage /usr/lib/x86_64-linux-gnu/libav*.so* /usr/lib/x86_64-linux-gnu/
COPY --from=ffmpeg-stage /usr/lib/x86_64-linux-gnu/libsw*.so* /usr/lib/x86_64-linux-gnu/
COPY --from=ffmpeg-stage /usr/lib/x86_64-linux-gnu/libpostproc*.so* /usr/lib/x86_64-linux-gnu/
USER node 