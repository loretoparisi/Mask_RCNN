FROM ubuntu:18.04

MAINTAINER Loreto Parisi loretoparisi@gmail.com

WORKDIR /root

########################################  BASE SYSTEM
# set noninteractive installation
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y apt-utils
RUN apt-get install -y --no-install-recommends \
    build-essential \
    pkg-config \
    tzdata \
    curl

######################################## PYTHON3
RUN apt-get install -y \
    python3 \
    python3-pip

# set local timezone
RUN ln -fs /usr/share/zoneinfo/America/New_York /etc/localtime && \
    dpkg-reconfigure --frontend noninteractive tzdata

# maskrcnn
ENV PYTHONPATH /usr/local/lib/python3.6 
COPY . ./
COPY requirements.txt /tmp/requirements.txt
RUN pip3 install -r /tmp/requirements.txt
RUN python3 setup.py install

# model zoo
RUN curl https://github.com/matterport/Mask_RCNN/releases/download/v2.0/mask_rcnn_coco.h5 > mask_rcnn_coco.h5

CMD ["jupyter notebook --ip 0.0.0.0 --no-browser --allow-root"]