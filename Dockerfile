FROM ubuntu:14.04.1
MAINTAINER Pete Nelson

RUN export DEBIAN_FRONTEND=noninteractive \
    # remove the http_proxy line or update as needed for your environment
    && export http_proxy=http://192.168.255.129:3142 \
    && apt-get update \
    && apt-get install --no-install-recommends -y \
            ca-certificates \
            git \
            libev4 \
            libffi6 \
            python-bson \
            python-dev \
            python-geoip \
            python-openssl \
            python-pip \
            python-pymongo \
            #unzip \
            #wget \
        \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN export DEBIAN_FRONTEND=noninteractive \
    # remove the http_proxy line or update as needed for your environment
    && http_proxy=http://192.168.255.129:3142 apt-get update \
    && http_proxy=http://192.168.255.129:3142 apt-get install --no-install-recommends -y \
            build-essential \
            libev-dev \
            libffi-dev \
            libssl-dev \
        \
    && pip install -e git+https://github.com/rep/evnet.git#egg=evnet-dev \
    && apt-get purge -y \
            build-essential \
            libev-dev \
            libffi-dev \
            libssl-dev \
        \
    && apt-get autoremove --purge -y \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

COPY \
        init \
        lib/hpfeeds.py \
        examples/geoloc/geoloc.py \
        examples/geoloc/processors.py \
        broker/feedbroker.py \
        broker/add_user.py \
        broker/dump_users.py \
        cli/hpfeeds-client \
    /hpfeeds/

RUN groupadd -r -g 1500 hpfeeds \
    && useradd -r -g hpfeeds -u 1500 hpfeeds \
    && chmod 755 /hpfeeds/* \
    && chown -R hpfeeds:hpfeeds /hpfeeds

# this should be published, or used by containers linking to us
EXPOSE 10000

# this volume is where
VOLUME /opt/

USER hpfeeds
ENTRYPOINT ["/hpfeeds/init"]
CMD ["help"]

