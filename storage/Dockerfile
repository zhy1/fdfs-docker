#
# FastDFS Storage Dockerfile
#
# Pull base images.
FROM centos:7
MAINTAINER phinexdaz <https://github.com/phinexdaz>
# Install env
RUN yum -y install wget gcc git make unzip vixie-cron && yum clean all
# Set timezone
RUN cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
# Ready
RUN groupadd nginx && \
    useradd -g nginx nginx -s /bin/false

RUN wget http://mirror.centos.org/centos/7/extras/x86_64/Packages/epel-release-7-11.noarch.rpm && \
    rpm -ivh epel-release-7-11.noarch.rpm && \
    rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-7

# Install dependencies
RUN yum -y install pcre pcre-devel openssl openssl-devel lua-devel && \
    yum -y install readline readline-devel perl-ExtUtils-Embed  && \
    yum -y install libjpeg libjpeg-devel libpng libpng-devel giflib giflib-devel freetype freetype-devel  openjpeg openjpeg-devel  && \
    yum -y install GraphicsMagick GraphicsMagick-devel  && \
    yum clean all

# Download and install package
RUN cd /tmp && \
    git clone https://github.com/happyfish100/fastdfs.git && \
    git clone https://github.com/happyfish100/libfastcommon.git && \
    git clone https://github.com/LuaJIT/LuaJIT.git && \
    git clone https://github.com/simpl/ngx_devel_kit.git && \
    git clone https://github.com/openresty/lua-nginx-module.git && \
    git clone https://github.com/openresty/echo-nginx-module.git && \
    git clone https://github.com/FRiCKLE/ngx_cache_purge.git && \
    git clone https://github.com/happyfish100/fastdfs-nginx-module.git && \
    wget http://nginx.org/download/nginx-1.15.0.tar.gz

RUN cd /tmp && \
    tar zxvf nginx-1.15.0.tar.gz && \
    cd libfastcommon && \
    git checkout V1.0.36 -f && \
    ./make.sh  && \
    ./make.sh install && \
    ln -s /usr/lib64/libfastcommon.so /usr/local/lib/libfastcommon.so && \
    ln -s /usr/lib64/libfdfsclient.so /usr/local/lib/libfdfsclient.so && \
    cd ../fastdfs && \
    git checkout V5.11 -f && \
    ./make.sh  && \
    ./make.sh install && \
    cd ../LuaJIT && \
    make && make install PREFIX=/usr/local/lj2 && \
    export LUAJIT_LIB=/usr/local/lj2/lib && \
    export LUAJIT_INC=/usr/local/lj2/include/luajit-2.0 && \
    cd ../nginx-1.15.0 && \
    ./configure --prefix=/usr/local/nginx --user=nginx --group=nginx --with-http_stub_status_module --with-http_ssl_module --with-http_realip_module --with-http_addition_module --with-http_sub_module --with-http_dav_module --with-http_flv_module --with-http_gzip_static_module --add-module=/tmp/ngx_cache_purge --add-module=/tmp/fastdfs-nginx-module/src --add-module=/tmp/ngx_devel_kit --add-module=/tmp/echo-nginx-module/ --with-ld-opt=-Wl,-rpath,/usr/local/lj2/lib --add-module=/tmp/lua-nginx-module/ && \
    make && make install && \
    mv /usr/local/nginx/conf/nginx.conf /usr/local/nginx/conf/nginx.conf.bak && \
    mkdir /usr/local/nginx/conf/lua && \
    echo "0 2 * * * find /data/storage/data/ -name *.*_*x*.* -atime -7 | xargs rm -rf" >> /etc/crontab && \
    mv /etc/fdfs/storage.conf.sample /etc/fdfs/storage.conf && \
    mv /etc/fdfs/client.conf.sample /etc/fdfs/client.conf && \
    cp /tmp/fastdfs-nginx-module/src/mod_fastdfs.conf /etc/fdfs/ && \
    cp /tmp/fastdfs/conf/http.conf /etc/fdfs/ && \
    cp /tmp/fastdfs/conf/mime.types /etc/fdfs/ && \
    sed -i 's:base_path=.*:base_path=/data/storage:g' /etc/fdfs/storage.conf && \
    sed -i 's:store_path0=.*:store_path0=/data/storage:g' /etc/fdfs/storage.conf && \
    sed -i 's:base_path=.*:base_path=/data/storage:g' /etc/fdfs/client.conf && \
    sed -i 's:base_path=.*:base_path=/data/storage:g' /etc/fdfs/mod_fastdfs.conf && \
    sed -i 's:store_path0=.*:store_path0=/data/storage:g' /etc/fdfs/mod_fastdfs.conf && \
    rm -rf /tmp/*

VOLUME ["/data/storage"]

# Cpoy File
COPY file/nginx.conf /usr/local/nginx/conf/
COPY file/thumbnail.lua /usr/local/nginx/conf/lua/
COPY file/entrypoint.sh /

EXPOSE 80 23000 8888

ENTRYPOINT ["/entrypoint.sh"]