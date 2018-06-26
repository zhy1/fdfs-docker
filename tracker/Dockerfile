#
# FastDFS Tracker Dockerfile
#
# Pull base images.
FROM centos:7
MAINTAINER phinexdaz <https://github.com/phinexdaz>
# Install env
RUN yum -y install wget gcc git make unzip vixie-cron && yum clean all

# Set timezone
RUN cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

# Download and install package
RUN cd /tmp && \
    git clone https://github.com/happyfish100/fastdfs.git && \
    git clone https://github.com/happyfish100/libfastcommon.git

RUN cd /tmp && \
    cd libfastcommon && \
    git checkout V1.0.36 -f && \
    git branch && \
    ./make.sh  && \
    ./make.sh install && \
    ln -s /usr/lib64/libfastcommon.so /usr/local/lib/libfastcommon.so && \
    ln -s /usr/lib64/libfdfsclient.so /usr/local/lib/libfdfsclient.so && \
    cd ../fastdfs && \
    git checkout V5.11 -f && \
    git branch && \
    ./make.sh  && \
    ./make.sh install && \
    mv /etc/fdfs/tracker.conf.sample /etc/fdfs/tracker.conf && \
    sed -i 's:base_path=.*:base_path=/data/tracker:g' /etc/fdfs/tracker.conf && \
    rm -rf /tmp/*


VOLUME ["/data/tracker"]
EXPOSE 22122
COPY file/entrypoint.sh /

ENTRYPOINT ["/entrypoint.sh"]