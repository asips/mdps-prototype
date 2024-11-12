FROM gitlab.ssec.wisc.edu:5555/sips/viirs_l1-build/viirsl1:v3.2.3

USER root
RUN dnf -yq install \
    curl \
    python3.12-pip && \
  dnf -yqq clean all

RUN cd /tmp && \
  curl -sSf -L -o ccsds.tar.gz https://github.com/bmflynn/ccsds-rs/releases/download/0.1.0-beta.17/ccsds_0.1.0-beta.17.tar.gz && \
  tar xf ccsds.tar.gz && \
  mv -v x86_64-unknown-linux-musl/ccsds /usr/local/bin/

COPY docker/requirements.txt /tmp/
RUN $APPDIR/bin/python3 -m pip install -r /tmp/requirements.txt
COPY scripts/catgen /usr/local/bin/
COPY workflows/viirsl1/scripts/level1a /usr/local/bin/
COPY workflows/viirsl1/scripts/level1b /usr/local/bin/

ENTRYPOINT ["tini", "--"]
