# Updated Spectre Dockerfile

This is a fork of dexafree/ghostbin Dockerfile
but include recent package and security update for spectre (formely known as ghostbin)

## New Usage

If you provisionned with "ghostbin" before you need to:
- rename every "ghostbin" folder by "spectre-updated" from now on, it mean if you data folder is "/var/data/ghostbin" you should rename it: "/var/data/spectre-updated"


Run this command to launch spectre on the port 8619
```
docker run -it -d --name="spectre-updated" -p 8619:8619 -v /var/log/spectre-updated:/logs -v /var/data/spectre updated:/data borrougagnou/spectre-updated
```

---
### Changelog (YYYYMMDD)
##### 20250221
- Begin to rename all "ghostbin" by "spectre"
- Dockerfile :
  - golang : 1.21.0 -> 1.24.0
  - alpine : 3.18  -> 3.21
  - [Fixed the entrypoint for docker](https://docs.docker.com/reference/build-checks/json-args-recommended/)
- Spectre (formely known as Ghostbin):
  - use the latest version of the spectre-updated repository

##### 20231129
- Dockerfile :
  - golang : 1.17.7 -> 1.21.0
  - alpine : 3.15 -> 3.18
- Ghostbin/spectre :
  - use the latest version

##### 20220211
- Dockerfile :
  - golang : 1.8.3 -> 1.17.7
  - alpine : 3.06  -> 3.15

---
## author readme:

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

As the [master branch of the Ghostbin/Spectre project](https://github.com/DHowett/spectre/commit/90de2d7c989a603cf494eae3d31ec88420ebe750) (link to the latest master commit at the time of writing this readme) is not stable right now (it has mixed namespaces and is in the middle of a refactor), this Dockerfile uses the latest commit in the `v1-stable` branch, so it will probably not be running the exact same Ghostbin version the production server is running.

I spoke to the author and he told me he is working in making it stable, so in the future this image should adapt to the latest version.

## Usage

In order to run the image, you need to know three things:

1. Ports: This image exposes the 8619 port for serving the Spectre site.
2. Logs volume: This image exposes a `logs` volume, so you are able to read the logs that Spectre outputs. The path inside the container will be `/logs`
3. Data volume: This image exposes a `data` volume, so you are able to access and persist things like pastes, session keys and accounts through containers (and survive restarts).

So, a way to run this container exposing all 3 things would be:

```
docker run -it -d --name="spectre-updated" -p 8619:8619 -v /var/log/spectre-updated:/logs -v /var/data/spectre updated:/data borrougagnou/spectre-updated
```

It would expose the 8619 port of the host machine, mount the `logs` volume at the local path `/var/log/spectre-updated` and mount the `data` volume at the local path `/var/data/spectre-updated`. You can adapt it to any use you need.

