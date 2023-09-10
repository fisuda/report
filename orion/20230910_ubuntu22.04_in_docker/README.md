- build container

```
docker build -t orion-ubuntu22.04 --build-arg IMAGE_NAME=ubuntu --build-arg IMAGE_TAG=22.04 --build-arg CLEAN_DEV_TOOLS=0 --progress plain . |& tee ~/build.log
```

- docker-compose.yml

```
version: "3"

services:
  orion:
    image: orion-ubuntu22.04:latest
    ports:
      - "1026:1026"
    depends_on:
      - mongo
    command: -dbhost mongo

  mongo:
    image: mongo:4.4
    command: --nojournal
```

- Ubuntu 22.04 on x86_64

```
$ curl http://localhost:1026/version
{
"orion" : {
  "version" : "3.10.0-next",
  "uptime" : "0 d, 0 h, 0 m, 13 s",
  "git_hash" : "7b6275bb053701af043ed05536ce8facc46f0efc",
  "compile_time" : "Sun Sep 10 02:01:01 UTC 2023",
  "compiled_by" : "root",
  "compiled_in" : "buildkitsandbox",
  "release_date" : "Sun Sep 10 02:01:01 UTC 2023",
  "machine" : "x86_64",
  "doc" : "https://fiware-orion.rtfd.io/",
  "libversions": {
     "boost": "1_74",
     "libcurl": "libcurl/7.81.0 OpenSSL/3.0.2 zlib/1.2.13 brotli/1.0.9 zstd/1.4.8 libidn2/2.3.2 libpsl/0.21.0 (+libidn2/2.3.2) libssh/0.9.6/openssl/zlib nghttp2/1.43.0 librtmp/2.3 OpenLDAP/2.5.16",
     "libmosquitto": "2.0.15",
     "libmicrohttpd": "0.9.76",
     "openssl": "3.0.2",
     "rapidjson": "1.1.0",
     "mongoc": "1.24.3",
     "bson": "1.24.3"
  }
}
}
```

- Ubuntu 22.04 on aarch64

```
{
"orion" : {
  "version" : "3.10.0-next",
  "uptime" : "0 d, 0 h, 0 m, 10 s",
  "git_hash" : "7b6275bb053701af043ed05536ce8facc46f0efc",
  "compile_time" : "Sun Sep 10 02:17:40 UTC 2023",
  "compiled_by" : "root",
  "compiled_in" : "buildkitsandbox",
  "release_date" : "Sun Sep 10 02:17:40 UTC 2023",
  "machine" : "aarch64",
  "doc" : "https://fiware-orion.rtfd.io/",
  "libversions": {
     "boost": "1_74",
     "libcurl": "libcurl/7.81.0 OpenSSL/3.0.2 zlib/1.2.13 brotli/1.0.9 zstd/1.4.8 libidn2/2.3.2 libpsl/0.21.0 (+libidn2/2.3.2) libssh/0.9.6/openssl/zlib nghttp2/1.43.0 librtmp/2.3 OpenLDAP/2.5.16",
     "libmosquitto": "2.0.15",
     "libmicrohttpd": "0.9.76",
     "openssl": "3.0.2",
     "rapidjson": "1.1.0",
     "mongoc": "1.24.3",
     "bson": "1.24.3"
  }
}
}
```
