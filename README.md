# Updated Ghostbin Dockerfile

This is a fork of dexafree/ghostbin Dockerfile
but include recent package and security update for ghostbin/spectre

- Dockerfile
golang : 1.8.3 -> 1.17.6
alpine : 3.06  -> 3.15

- ghostbin/spectre
grunt     : 1.0.1 -> 1.4.1
grunt-cli : 1.2.0 -> 1.4.3
grunt-contrib-clean  : 1.1.0 -> 2.0.0
grunt-contrib-concat : 1.0.1 -> 2.0.0
grunt-contrib-copy   : 1.0.0 -> 1.0.0
grunt-contrib-cssmin : 2.2.1 -> 4.0.0
grunt-contrib-less   : 1.4.1 -> 3.0.0
grunt-contrib-uglify : 3.1.0 -> 5.0.1
grunt-filerev        : 2.3.1 -> 2.3.1
grunt-usemin         : 3.1.1 -> REMOVED unmaintained + critical security
load-grunt-tasks     : 3.5.2 -> 5.1.0



This is a repository I've created in order to have a Docker image for running [Ghostbin](https://ghostbin.com) in a private server.

It allows you to run it in your own computer, internally in your company, or host it in a public server.

The [Ghostbin project](https://github.com/DHowett/spectre) is also Open Source, but due to its hard setup, I thought that creating a Dockerfile and a Docker image would be helpful for people like me who want to host it on their own hardware.

## Base image

The base image used for this Dockerfile is `golang:1.8.3-alpine3.6`:

* Golang as Ghostbin is written in Go, an thus is needed to compile it.
* Alpine as it provides a smaller base image, and therefore the resulting image will also be smaller.

## Limitations

In order for expiration, encryption and syntax highlighting to work, you need to be using Docker in a Linux system.

This is due to a difference in the internal Filesystem Docker for Linux uses: The FS driver used on Docker for macOS and Docker for Windows does not support the use of `xattrs` (extended attributes: saving metadata for a file in the filesystem), and Ghostbin relies on those attributes for saving the paste properties, such as the language, the encryption password and the expiration (if any of those is set).

So, you will need to run it on a host using Docker for Linux in order for them to work.

## Notes

As the [master branch of the Ghostbin project](https://github.com/DHowett/spectre/commit/90de2d7c989a603cf494eae3d31ec88420ebe750) (link to the latest master commit at the time of writing this readme) is not stable right now (it has mixed namespaces and is in the middle of a refactor), this Dockerfile uses the latest commit in the `v1-stable` branch, so it will probably not be running the exact same Ghostbin version the production server is running.

I spoke to the author and he told me he is working in making it stable, so in the future this image should adapt to the latest version.

## Usage

In order to run the image, you need to know three things:

1. Ports: This image exposes the 8619 port for serving the Ghostbin site.
2. Logs volume: This image exposes a `logs` volume, so you are able to read the logs that Ghostbin outputs. The path inside the container will be `/logs`
3. Data volume: This image exposes a `data` volume, so you are able to access and persist things like pastes, session keys and accounts through containers (and survive restarts).

So, a way to run this container exposing all 3 things would be:

```
docker run -it -d --name="ghostbin" -p 8619:8619 -v /var/log/ghostbin:/logs -v /var/data/ghostbin:/data dexafree/ghostbin
```

It would expose the 8619 port of the host machine, mount the `logs` volume at the local path `/var/log/ghostbin` and mount the `data` volume at the local path `/var/data/ghostbin`. You can adapt it to any use you need.
