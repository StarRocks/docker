# docker 

## 文件说明

```
.
├── docker_make.sh      # image 构建脚本
├── params.sh           # 参数脚本，配置构建 image 的参数
├── README.md
├── sr-thirdparty       # thirdparty image 构建文件夹
│   ├── Dockerfile
│   └── start.sh
└── sr-toolchain        # toolchain image 构建文件夹
    └── Dockerfile
    └── install.sh    
```

## 构建对应版本编译环境的 `starrocks/thirdparty` 镜像

1. 配置 params.sh
2. 执行 docker_make.sh

## 版本

- starrocks main <===> docker image main
> main 分支的三方依赖变更，需要重新 build main 分支对应的 `starrocks/thirdparty:main`
- starrocks release version <===> docker image version
> 发布新版本，需要 release 对应版本的 `starrocks/thirdparty:{version}`

## 使用 `starrocks/thirdparty` 进行 `starrocks` 的编译

1. `docker run -it -d --{container-name} starrocks/thirdparty:{version}`
2. `docker exec -it {container-name} /bin/bash`
3. 进入 container，在任意目录下 clone starrocks 对应分支代码，可直接执行 starrocks/build.sh 进行编译
4. 编译完成后，可使用 `docker cp {container-name}:/xx/xx /xx/xx/` 将需要的二进制包 copy 到宿主机上