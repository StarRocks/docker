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
```

## 使用方式

- 配置 params.sh
- 执行 docker_make.sh

## 版本关系

- starrocks main <===> docker image main

- starrocks release version <===> docker image version






