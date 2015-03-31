FROM siutin/ubuntu-rails:latest
MAINTAINER Martin Chan <osiutino@gmail.com>
ENV REFRESHED_AT 2015-03-31

USER root

# Update
#RUN apt-get update

# apache setup ---------------------------------------------------

# Apache
RUN apt-get -y install apache2 apache2-mpm-worker

# Mods
RUN a2enmod rewrite

RUN apachectl restart

# passenger dependencies --------------------------------------------- >>

RUN apt-get install -y nodejs --no-install-recommends

# Curl development headers with SSL support
RUN apt-get install -y libcurl4-openssl-dev

# Apache 2 development headers
RUN apt-get install -y apache2-threaded-dev

# Apache Portable Runtime (APR) development headers
RUN apt-get install -y libapr1-dev

# Apache Portable Runtime Utility (APU) development headers
RUN apt-get install -y libaprutil1-dev

# ----------------------------------------------------------------------- <<

USER worker

ENV PASSENGER_VERSION 4.0.59

RUN /bin/bash -l -c 'gem install passenger --version $PASSENGER_VERSION --no-rdoc --no-ri'
RUN /bin/bash -l -c 'passenger-install-apache2-module --auto'

# ----------------------------------------------------------------------

# clean apt caches
rm -rf /var/lib/apt/lists/*