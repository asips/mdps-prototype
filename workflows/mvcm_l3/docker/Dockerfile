ARG basetag=latest
FROM gitlab.ssec.wisc.edu:5555/sips/mdps-images/base:${basetag}

# Deliveries and support software necessary to run pipeline
COPY software/mvcm_preyori/ /software/mvcm_preyori/
COPY docker/run_g3.py /software/run_g3.py
COPY docker/run_l3_aggr.py /software/run_l3_aggr.py

# Python package requirements for mvcm_g3
COPY docker/requirements.txt /software/
RUN python3 -m pip install -r /software/requirements.txt
