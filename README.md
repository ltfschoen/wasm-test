# README

---
WASM-TEST
---

Example programs compiled to [WebAssembly](http://webassembly.org/) (WASM), served over HTTP to a web server provided by Emscripted SDK, and then viewable in the Emscripten console of the webpage.

## Screenshots

* Hello example
![alt tag](https://raw.githubusercontent.com/ltfschoen/wasm-test/master/screenshots/webpage.png)

* Quiz example
![alt tag](https://raw.githubusercontent.com/ltfschoen/wasm-test/master/screenshots/quiz.png)

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
  * Alternative `docker-compose up --force-recreate --build -d && docker-compose exec sandbox bash`
* Use Emscripten to generate a binary WASM module (`.wasm`) from our C program (`.c`), a HTML (`.html`) page and JavaScript (`.js`) "glue" code to load, compile, and instantiate the WASM code and display its output in a web browser
  ```
  emcc /code/src/hello/hello.c -s WASM=1 -o /code/src/hello/hello.html

  emcc /code/src/question/question.c -s WASM=1 -o /code/src/question/question.html

  emcc /code/src/quiz/quiz.c -s WASM=1 -o /code/src/quiz/quiz.html
  ```
* Perform the above using a [custom HTML template](https://developer.mozilla.org/en-US/docs/WebAssembly/C_to_wasm): 
  ```
  emcc -o /code/src/hello2/hello2.html /code/src/hello2/hello2.c -O3 -s WASM=1 --shell-file /emsdk/emscripten/incoming/src/shell_minimal.html

  emcc -o /code/src/quiz2/quiz2.html /code/src/quiz2/quiz2.c -O3 -s WASM=1 --shell-file /code/src/quiz2/html_template/quiz2_minimal.html -s NO_EXIT_RUNTIME=1
  ```
* Run server in the container
  ```
  emrun --no_browser --no_emrun_detect --hostname=0.0.0.0 --port 8080 .
  ```
* View in a web browser
  * Go to http://localhost:5000/src/hello/hello.html (or http://<MACHINE_VM_IP>:5000/src/hello/hello.html)
  * Go to http://localhost:5000/src/hello2/hello2.html
  * Go to http://localhost:5000/src/question/question.html, enter a number in the popup window and press ENTER, then press CANCEL when the popup appears again.
  * Go to http://localhost:5000/src/quiz/quiz.html, enter 1 in popup window and press ENTER, then enter "wasm" in next popup window and press ENTER, then press CANCEL. View the browser Console to debug if freezes to view the C program `prinf` outputs. WARNING: Do not press CANCEL before first entering 1 to play the game or it will freeze.
  * Go to http://localhost:5000/src/quiz2/quiz2.html. Click the "Start Quiz" button. Enter 1 in popup window and press ENTER, then enter "wasm" in next popup window and press ENTER, then press CANCEL. View the browser Console to debug if freezes to view the C program `prinf` outputs. WARNING: Do not press CANCEL before first entering 1 to play the game or it will freeze. 

## TODO <a id="chapter-todo"></a>

* [ ] - Fix so displays outputs on screen immediately without blocking when requesting user input in popup window
* [ ] - Fix so compiling the programs within the Dockerfile generates all outputs. Currently it only works when you compile once you are in the container bash. The repository source control already contains all pre-compiled outputs. 
* [ ] - Get CMake from apt-get if possible
* [ ] - Get Python 2.7 with apt-get install python2 and also python2-dev
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
3. Problem: `quiz.c` initially did not show the output in the Emscripten console of the webpage, even though running the compiled C program works by running the compiled file with `./src/quiz/quiz`
  * Solution: After reading the ["Calling a custom function defined in C" section at this link](https://developer.mozilla.org/en-US/docs/WebAssembly/C_to_wasm) it highlighted that if you create any other functions in the C program such as `int menu()` other than the default `main()` function, then you have to apply the `EMSCRIPTEN_KEEPALIVE` declaration to it (i.e. `int EMSCRIPTEN_KEEPALIVE menu()` to adds the functions to the exported functions list, otherwise that function will be eliminated as dead code and vanish when you compile the C program to JavaScript. Additionally, in order to use `EMSCRIPTEN_KEEPALIVE`, you have to import `#include <emscripten/emscripten.h>` at the top of the same C program file.

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

* How can I compile a C program on macOS using GCC (without WASM)?
  ```
  gcc ./src/question/question.c -o ./src/question/question; ./src/question/question;
  gcc ./src/quiz/quiz.c -o ./src/quiz/quiz; ./src/quiz/quiz;
  ```

* How to write a basic C program?
  * Reference: https://www.physics.ohio-state.edu/~ntg/780/handouts/interactive_input_in_C.pdf

* What are strings in C language?
  * Reference: https://stackoverflow.com/questions/14709323/does-c-have-a-string-type

* How to use `sscanf` in C language?
  * Reference: http://docs.roxen.com/pike/7.0/tutorial/strings/sscanf.xml

* How to assign to an array in C language?
  * Reference: https://stackoverflow.com/questions/32313150/array-type-char-is-not-assignable

## References <a id="chapter-references"></a>

* Web Assembly (WASM) Developers Guide - http://webassembly.org/getting-started/developers-guide/
* Create a Dockerfile - https://docs.docker.com/compose/gettingstarted/#step-2-create-a-dockerfile
* Mozilla WASM - https://developer.mozilla.org/en-US/docs/WebAssembly/C_to_wasm
