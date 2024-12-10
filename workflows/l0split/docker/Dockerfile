ARG basetag=latest

FROM gitlab.ssec.wisc.edu:5555/sips/mdps-images/base:${basetag}

RUN cd /tmp && \
  curl -sSf -L -o ccsds.tar.gz https://github.com/bmflynn/ccsds-rs/releases/download/0.1.0-beta.17/ccsds_0.1.0-beta.17.tar.gz && \
  tar xf ccsds.tar.gz && \
  mv -v x86_64-unknown-linux-musl/ccsds /usr/local/bin/

RUN python3 -m pip install pystac "ccsds>=0.1.0b20"
COPY ./workflows/scripts/level0split /usr/local/bin/
