FROM ubuntu:23.10

MAINTAINER toconnor <toconnor@my.fit.edu>
LABEL contributor="chake <chake2019@my.fit.edu>"

ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=America/New_York
ENV LANG en_US.UTF-8

# apt-get installs
RUN apt-get update -y -qq
RUN apt-get install -y -qq \
    g++ \
    gcc \
    gcc-multilib \
    gdb \
    gdb-multiarch \
    git \
    locales \
    make \
    man \
    nano \
    nasm \
    pkg-config \
    tmux \
    wget \
    python3-pip \
    ruby-dev \
    meson

RUN pip3 install --upgrade pip

RUN python3 -m pip install --no-cache-dir --upgrade \
    autopep8 \
    capstone \
    colorama \
    cython \
    keystone-engine \
    pefile \
    pwntools \
    qiling \
    r2pipe \
    ropgadget \
    ropper \
    sudo \
    unicorn \
    z3-solver \
    rzpipe

# install angr after dependencies met
RUN pip3 install angr angrop --upgrade

RUN git clone https://github.com/rizinorg/rizin && \
    cd rizin && \
    meson setup build && \
    meson compile -C build && \
    meson install -C build

# install angrop from source -- fixes "rop" import error 
RUN cd /opt/ && git clone https://github.com/angr/angrop && \
    cd angrop && pip3 install .

# install pwninit for patching bins for ctfs     
RUN wget -O /bin/pwninit https://github.com/io12/pwninit/releases/download/3.3.0/pwninit && \
    chmod +x /bin/pwninit

# install pwndbg
RUN cd /opt/ && git clone https://github.com/pwndbg/pwndbg && \
  cd pwndbg && \
  ./setup.sh

# install stuff for patching binaries with libc
RUN apt-get update -qq -y && apt-get install -qq -y patchelf elfutils

RUN apt-get full-upgrade -qq -y && apt-get clean -qq -y && apt-get autoclean -qq -y && apt-get autoremove -qq -y

# RUN sed -i "s/angr\.DEFAULT_CC\[self\.project\.arch\.name\](self\.project\.arch)/angr\.default_cc(self\.project\.arch\.name,platform=self\.project\.simos\.name if self\.project\.simos is not None else None,)(self\.project\.arch)/g" /usr/local/lib/python3.10/dist-packages/angrop/chain_builder/__init__.py

WORKDIR /
 
# enable core dumping
RUN ulimit -c unlimited

RUN echo "flag{fake-flag}" > /flag.txt

# copy over libc.so.6 and ld-2.27
COPY libc/libc.so.6 /opt/libc.so.6 
COPY libc/ld-2.27.so /opt/ld-2.27.so

COPY exploit.py /exploit.py

CMD ["python3", "exploit.py"]

