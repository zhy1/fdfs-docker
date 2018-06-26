# fdfs-docker

- 1 合并 2个项目

- 2 修改 所有具体的版本保证可用性[包括fdfs fastcommon epel-release-7-11.noarch.rpm]

- 3 修改 entrypoint中storage连接tacker的外网地址为/etc/profile中或者启动参数指定

- 3 注意 重启时如果出现file: tracker_proto.c, line: 48, 可以进行删除tracker文件，

- 4 说明 tracker为主master storage为从node

- 5 说明 可以删除tracker文件和storage中的pid文件不会影响已经保存的数据



## 1 setup Env localIp = WAN IP   for tracker connect storage.
echo localIp=1.2.3.4  >> /etc/profile

## 2 build image 
```
cd tracker && docker build -t fdfs_tracker .
cd storage && docker build -t fdfs_storage .
```

## 3 create container 
`
docker run -d --name tracker -v /app/fdfs/data/tracker:/data/tracker -p 22122:22122 fdfs_tracker
`

`
docker run -d --name storage -v /app/fdfs/data/storage:/data/storage --link tracker:tracker -p 80:80 -p 23000:23000 -p 8888:8888 -e TRACKER=tracker fdfs_storage
`


## 4 log
```
docker logs tracker
docker logs storage 
```

## 5 delete 
docker rm storage  tracker -f


## 6 debug  [@before dockerfile delete entrypoint.sh]
`docker run -it --name storage -v /app/fdfs/data/storage:/data/storage \
  --link tracker:tracker \
  -p 80:80 -p 23000:23000 -p 8888:8888 \
  -e TRACKER=tracker fdfs_storage /bin/bash`
  
`docker run -it --name tracker -v /app/fdfs/data/tracker:/data/tracker -p 22122:22122 fdfs_tracker /bin/bash`






# bug fix:

* storage启动时，file: tracker_proto.c, line: 48, server: *:22122, response status 22 != 0

- 表示storage的pid和tracker对应不上，可以删除tracker的data 和 storage 的pid


