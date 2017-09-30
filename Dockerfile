FROM fedora:26
MAINTAINER Gerard Braad <me@gbraad.nl>

RUN mkdir -p /workspace; \
    dnf install -y sudo; \
    adduser user -u 1000 -g 0 -r -m -d /home/user/ -c "Default Application User" -l; \
    echo "user ALL=(root) NOPASSWD:ALL" > /etc/sudoers.d/user; \
    chmod 0440 /etc/sudoers.d/user; \
    chown user:root /workspace; \
    chmod -R g+rw /home/user; \
    dnf clean all

VOLUME /workspace
WORKDIR /workspace

RUN dnf install -y libstdc++

ARG GODOT_VERSION=2.1.4
ARG GODOT_VARIANT=stable

RUN dnf install -y wget unzip; \
    cd /tmp; \
    wget "http://download.tuxfamily.org/godotengine/${GODOT_VERSION}/Godot_v${GODOT_VERSION}-${GODOT_VARIANT}_linux_server.64.zip" \
"http://downloads.tuxfamily.org/godotengine/${GODOT_VERSION}/Godot_v${GODOT_VERSION}-${GODOT_VARIANT}_export_templates.tpz"; \
    unzip Godot_v*_linux_server.64.zip; \
    mv Godot_v*_linux_server.64 /usr/local/bin/godot; \
    mkdir -p /home/user/.godot; \
    unzip -d /home/user/.godot Godot_v*_export_templates.tpz; \
    chown user:root -R /home/user/.godot; \
    dnf history undo 4 -y; \
    rm -f *.zip *.tpz; \
    dnf clean all

USER 1000
ENTRYPOINT ["/usr/local/bin/godot"]

