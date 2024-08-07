FROM rockylinux/rockylinux:9

ARG version

RUN dnf -y -q install epel-release && \
  dnf -y -q install netcdf && \
  dnf -y -q clean all 

COPY ${version}/ /opt/mvcm/

ENV LD_LIBRARY_PATH=/opt/mvcm/dist/lib
ENV PATH=$PATH:/opt/mvcm/dist

RUN useradd app
USER app
