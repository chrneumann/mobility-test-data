FROM debian:bookworm-slim
LABEL org.opencontainers.image.source=https://github.com/chrneumann/mobility-test-data

# Prevent removal of tilemaker examples
RUN echo path-include /usr/share/doc/tilemaker/examples/* >> /etc/dpkg/dpkg.cfg.d/docker

# Install osmium, tilemaker and wget
RUN apt-get update \
  && apt-get install -y wget osmium-tool tilemaker \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /opt

# Install pmtiles
RUN wget https://github.com/protomaps/go-pmtiles/releases/download/v1.19.1/go-pmtiles_1.19.1_Linux_x86_64.tar.gz -O pmtiles.tar.gz \
   && tar xvf pmtiles.tar.gz

# Run the convertion
COPY --chmod=744 create_data.sh create_data.sh
ENTRYPOINT ["./create_data.sh"]
