FROM centos:7

RUN yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm && \
    yum update -y && \
    yum install -y \
        ImageMagick \
        transfig \
        file \
        firefox \
        gcc \
        gcc-c++ \
        git \
        kstart \
        libffi-devel \
        libxml2-devel \
        libxslt-devel \
        mailcap \
        make \
        nodejs \
        npm \
        openssl-devel \
        poppler-utils \
        postgresql \
        postgresql-libs \
        postgresql-devel \
        python-pip \
        python-devel \
        python2-xrootd \
        wget \
        Xvfb \
        && \
    yum clean all
RUN npm install -g \
        node-sass@3.8.0 \
        clean-css@^3.4.24 \
        requirejs \
        uglify-js


WORKDIR /code

RUN pip install --no-cache-dir --upgrade pip==20.3.4 && \
    pip install --no-cache-dir --upgrade setuptools && \
    pip install --no-cache-dir --upgrade wheel

COPY . .

RUN pip install --ignore-installed --requirement requirements.txt && \
    pip install -e .

WORKDIR /usr/var/scoap3-instance/static

RUN scoap3 npm && \
    npm install && \
    scoap3 collect -v && \
    scoap3 assets build

WORKDIR /code
