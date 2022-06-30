FROM ubuntu:20.04

# non interactive frontend for locales
ARG DEBIAN_FRONTEND=noninteractive

# installing texlive and utils
RUN apt-get update \
    && apt-get install -y --no-install-recommends build-essential wget pandoc texlive-full biber latexmk make git procps locales curl openssh-client \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    && apt-get autoremove -y

# generating locales
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    dpkg-reconfigure --frontend=noninteractive locales && \
    update-locale LANG=en_US.UTF-8
ENV LANGUAGE=en_US.UTF-8 LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8

# installing cpanm & missing latexindent dependencies
RUN curl -L http://cpanmin.us | perl - --self-upgrade && \
    cpanm Log::Dispatch::File YAML::Tiny File::HomeDir

ENV PATH="/usr/local/miniconda3/bin:${PATH}"
ARG PATH="/usr/local/miniconda3/bin:${PATH}"
RUN wget \
    https://repo.anaconda.com/miniconda/Miniconda3-py38_4.12.0-Linux-x86_64.sh \
    && bash Miniconda3-py38_4.12.0-Linux-x86_64.sh -p /usr/local/miniconda3 -b \
    && rm -f Miniconda3-py38_4.12.0-Linux-x86_64.sh
RUN conda --version

RUN pip install pyscf numpy scipy matplotlib ipython jupyter pandas sympy h5py scikit-learn

ENTRYPOINT bash
