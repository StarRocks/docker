# Docker 

> To build with this script you need to have root privileges or use a user in the machine's docker group

## Introduction to the repo’s files

```
.
├── README.md
├── build-thirdparty.sh    # Thirdparty image build script
├── build-toolchain.sh     # Toolchain image build script
├── build.sh               # The script to automate toolchain and thirdparty image
├── params.sh              # The params file which build image will be used
├── sr-thirdparty          # Thirdparty dockerfile dir
│   └── Dockerfile
└── sr-toolchain           # Toolchain dockerfile dir
    ├── Dockerfile
    └── build-thirdparty.sh
```
## Build Process Introduction

1. Build image `starrocks/toolchain`.
2. Run `starrocks/toolchain` to create a container， execute the script build-thridpaty.sh which in the repo `starrocks` to build the build env.
3. Copy thirdparty from container to build `starrocks/dev-env`.

## How to build starrocks/dev-env

1. Modify params which in params.sh.
2. Execute the script build.sh to build image.

## How to build `starrocks` by using `starrocks/dev-env`

1. `docker run -it -d --{container-name} starrocks/dev-env:{version}`.
2. `docker exec -it {container-name} /bin/bash`.
3. Execute starrocks/build.sh to build the starrocks binary in any path which in the container.

## Version

- starrocks main <===> docker image main
> The main branch's thrird-party dependency has changed and the corresponding `starrocks/dev-env:main` for the main branch needs to be rebuilt.
- starrocks release version <===> docker image version
> To release a new version, you need to release the corresponding version of `starrocks/dev-env:{version}`.

