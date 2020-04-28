FROM plexinc/pms-docker

RUN \
# Update and get dependencies
    curl -sL https://deb.nodesource.com/setup_10.x | bash - && \
    apt-get update && \
    apt-get install -y \
      nodejs \
      git \
      iptables \
    && \

# Cleanup
    apt-get -y autoremove && \
    apt-get -y clean && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /tmp/* && \
    rm -rf var/tmp/*

EXPOSE 3001/tcp

COPY root/ /

RUN \
# Save versions and install
    /installUnicornLoadBalancer.sh && \
    /installUnicornFFMPEG.sh
