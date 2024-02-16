# CS 1660: development environment

This repo contains a minimal dev environment setup for CS 1660. In particular,
it provides the scripts to create the course Docker container.

## Getting started

```bash
# 1. load pre-built docker image
cd docker
./setup-container

# Alternate 1. build docker image locally
cd docker
./build-container

# 2. start development environment
cd ..
./cs1660-run-docker
```

For detailed setup instructions, refer to our [setup guide](https://hackmd.io/@cs1660/HyXQ9y1nj)!

## Wireshark setup

Wireshark is a tool for monitoring network traffic. Since docker does not offer
a graphical environment, running GUI applications (like wireshark) can be
tricky. However, there's a few tricks that can be leveraged to run GUI
applications. After looking at  host of options, we recommend the following
option through with the wireshark GUI can be exposed through any browser. We
have added the instructions below.

```bash
# 1. start the docker image. 
docker run -p 14500:14500 --restart unless-stopped --name wireshark --privileged ffeldhaus/wireshark

# 2. wireshrk GUI can be accessed here.
http://localhost:14500/?floating_menu=false&password=wireshark
```

The browser-based GUI is exactly the same as the regular one. Note that
```--privileged``` option is essential for allowing the packet capture.
Further, it is assumed that ```port 14500``` is free.

## Acknowledgments

This setup is a modified version of the setup used by
[CSCI0300](https://cs.brown.edu/courses/csci0300) and reused with
permission, which is based on [Harvard's CS61](https://cs61.seas.harvard.edu/site/2021/).  
For Wireshark, we have used the setup described in [Wireshark Web Container Image](https://github.com/ffeldhaus/docker-wireshark).
