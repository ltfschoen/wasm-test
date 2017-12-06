# README

---
WASM-TEST
---

Example programs compiled to [WebAssembly](http://webassembly.org/) (WASM), served over HTTP to a web server provided by Emscripted SDK, and then viewable in the Emscripten console of the webpage.

## Screenshots

![alt tag](https://raw.githubusercontent.com/ltfschoen/wasm-test/master/screenshots/webpage.png)

# Table of Contents
  * [Quick Start Guide](#chapter-0)
  * [TODO](#chapter-todo)
  * [Troubleshooting](#chapter-troubleshooting)
  * [FAQ](#chapter-faq)
  * [References](#chapter-faq)

## Quick Start Guide <a id="chapter-0"></a>

* Fork or Clone https://github.com/ltfschoen/wasm-test
* Install and run Docker for Mac
* Create container with image wasm_sandbox and run bash in it
  ```
  docker-compose up --force-recreate --build -d && docker exec -it $(docker ps -q) bash
  ```
* Run server in the container
  ```
  /emsdk/emscripten/incoming/emrun --no_browser --no_emrun_detect --hostname=0.0.0.0 --port 8080 .
  ```
* Go to http://localhost:5000/src/hello/hello.html (or http://<MACHINE_VM_IP>:5000/src/hello/hello.html)

## TODO <a id="chapter-todo"></a>

* [ ] - Other WASM Dockerfile Example - https://github.com/bgard6977/docker-wasm/blob/master/Dockerfile

## Troubleshooting <a id="chapter-troubleshooting"></a>

1. Problem: Error due to port mapping after previously running Docker `Bind for 0.0.0.0:5000 failed: port is already allocated`. 
  * Solution: Restart Docker for Mac
2. Problem: Insufficient disc space
  * Solution: Destroy all Docker images and containers 
  ```
  #!/bin/bash
  # Delete all containers
  docker rm $(docker ps -a -q)
  # Delete all images
  docker rmi $(docker images -q)
  ```

## FAQ <a id="chapter-faq"></a>

* How to memove Docker images and containers
```
docker ps -l
docker ps -a
docker stop <CONTAINER_ID>
docker rm <CONTAINER_ID>
docker images
docker rmi <IMAGE_ID>
```

* How to show Docker Machine information 
```
docker inspect <CONTAINER_ID>
```
* How to show the IP Address <MACHINE_VM_IP> of a container   
  * Reference: https://docs.docker.com/machine/reference/inspect/
```
docker inspect --format='{{.NetworkSettings.Networks.wasmtest_default.IPAddress}}' <CONTAINER_ID>
```

## References <a id="chapter-references"></a>

* Web Assembly (WASM) Developers Guide - http://webassembly.org/getting-started/developers-guide/
* Create a Dockerfile - https://docs.docker.com/compose/gettingstarted/#step-2-create-a-dockerfile
