ARG basetag=latest

FROM gitlab.ssec.wisc.edu:5555/sips/mdps-images/base:${basetag}
RUN python3 -m pip install pystac "ccsds>=0.1.0b16"
COPY ./workflows/scripts/level0split /usr/local/bin/
