#!/bin/bash
set -e

# configure http proxy system-wide
cat > /etc/profile.d/proxy.sh << EOT
PROXY_URL="http://10.77.1.3:3128/"
export http_proxy="\$PROXY_URL"
export https_proxy="\$PROXY_URL"
export ftp_proxy="\$PROXY_URL"
export no_proxy="127.0.0.1,localhost"
export HTTP_PROXY="\$PROXY_URL"
export HTTPS_PROXY="\$PROXY_URL"
export FTP_PROXY="\$PROXY_URL"
export NO_PROXY="127.0.0.1,localhost"
EOT

# use proxy for package manager
cat >> /etc/dnf/dnf.conf << EOT
proxy=http://10.77.1.3:3128
EOT

echo "Done."