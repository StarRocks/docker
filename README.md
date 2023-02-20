# docker 

This project is used to compile the StarRocks-dev-env image, which you can use to compile the StarRocks source code. The project will automatically compile the x86_64 or aarch64 image based on your system.If you don't want to compile it yourself, you can use the compiled image we provide [here](https://registry.hub.docker.com/r/starrocks/dev-env/tags).  
To use this project, you need to have root privileges or use a user in the docker group of the machine, and also need a running docker service.

## How to use
### Compile StarRocks-dev-env image
This project supports compiling image from StarRocks branch or PR, which is controlled by passing in parameters to build.sh. We can pass in three parameters, which have the following meaning.
```
sudo sh build.sh $1 $2 $3
# $1: Choose to use branch/tag/pr option
# $2: Branch name/tag name/pr id
# $3: The image name of the final successful compilation, which defaults is rc
# $4: The http proxy path, which defaults is ""
```
For example, if you want to use branch-2.4 latest code to compile the image, you can write like this
```
sudo sh build.sh branch branch-2.4
```
If you want to compile the image using the code from https://github.com/StarRocks/starrocks/pull/9436 and you have an http proxy address, you can write like this
```
sudo sh build.sh pr 9436 rc "http://x.x.x.x:port"
```
### Compile StarRocks using the image compiled in the previouse step
For specific steps, please refer to the [documentation](https://docs.starrocks.com/en-us/main/administration/Build_in_docker). For example, if we choose to use the `branch-2.2` to compile, `{version}` in the documentation will be `branch-2.2-rc`.

## Build Process Introduction
Description of the file structure
```
.
├── build.sh            # main script
├── sr-thirdparty       # thirdparty image build folder
└── sr-toolchain        # toolchain image build folder
```
1. Build the `starrocks/toolchain` image
2. Use the `starrocks/toolchain` image to start a container, execute the `starrocks/thirdparty` related scripts in the container, and copy the built folder to the host
3. Build the StarRocks-dev-env image based on the thirdparty build file generated in the previous step
