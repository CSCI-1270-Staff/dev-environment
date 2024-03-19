FROM ubuntu:jammy

LABEL org.opencontainers.image.source=https://github.com/CSCI-1270-Staff/dev-environment

# set environment variables for tzdata
ARG TZ=America/New_York
ENV TZ=${TZ}

# include manual pages and documentation
ARG DEBIAN_FRONTEND=noninteractive
ENV LANG en_US.UTF-8

COPY container-setup-amd64.sh /usr/local/bin/container-setup-amd64
COPY container-setup-common.sh /usr/local/bin/container-setup-common
COPY entrypoint.sh /usr/local/bin/container-entrypoint
COPY .image-version /etc/image-version

RUN /usr/local/bin/container-setup-amd64

# TODO: move to sontainer-setup-common.sh
# install conda so we can install jupyterlab

# We always download and install the latest miniconda3,
# and then downgrade python to specific version.
# We could instead download a specific miniconda3 version,
# but that would require baking in the URLs for
# different Miniconda installer versions into the Dockerfile.
RUN MINICONDA_URL="https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh"; \
    wget --quiet $MINICONDA_URL -O /tmp/miniconda.sh && \
    /bin/bash /tmp/miniconda.sh -b -p /opt/conda && \
    rm /tmp/miniconda.sh && \
    # Install the correct version of python (as the time of
    # writing, anaconda installed python 3.9 by default)
    /opt/conda/bin/conda install python=${FROM_PYTHON_VERSION} && \
    /opt/conda/bin/conda clean --all

ENV PATH=/opt/conda/bin:$PATH

ENV PIP_TARGET=/opt/conda/lib/python${FROM_PYTHON_VERSION}/site-packages

RUN conda install -c conda-forge jupyterlab
RUN conda install -c conda-forge gxx_linux-64==11.1.0 pandas

# git build arguments
ARG USER=cs1270\ User
ARG EMAIL=nobody@example.com

# configure your environment
USER cs1270-user

ENTRYPOINT ["container-entrypoint"]

WORKDIR /home/cs1270-user
CMD ["/bin/bash", "-l"]
