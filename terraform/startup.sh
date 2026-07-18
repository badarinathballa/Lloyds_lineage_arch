#!/bin/bash
apt-get update
apt-get install -y podman
echo "Podman installed: $(podman --version)" > /var/log/startup-script-done.log
