FROM mysql:5.7.17
LABEL maintainer Bert Oost <hello@bertoost.com>

RUN echo Europe/Amsterdam > /etc/timezone \
    && dpkg-reconfigure --frontend noninteractive tzdata

COPY conf.d/* /etc/mysql/temp/

# Rename temp files to .cnf + copy to conf.d/ directory (since that one is loaded)
RUN cd /etc/mysql/temp && rename "s/\.conf/\.cnf/" *.conf
RUN cp /etc/mysql/temp/*.cnf /etc/mysql/conf.d/