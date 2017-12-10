FROM ubuntu:latest
RUN apt-get update

# C compilers required for cmake
RUN apt-get install -y build-essential wget

# cmake - https://cmake.org/install/
ARG CMAKE_VERSION=3.10.0
RUN wget https://cmake.org/files/v3.10/cmake-${CMAKE_VERSION}.tar.gz
RUN tar xf cmake-${CMAKE_VERSION}.tar.gz && cd cmake-${CMAKE_VERSION} && ./bootstrap && make && make install

# git
RUN apt-get install -y git vim

# python
# RUN apt-get install -y openssl python3
# RUN wget https://bootstrap.pypa.io/get-pip.py -O - | python3
# RUN echo 'alias python="/usr/bin/python3"' >> ~/.bash_profile && . ~/.bash_profile

# python 2.7
RUN apt-get install -y checkinstall
RUN apt-get install -y libreadline-gplv2-dev libncursesw5-dev libssl-dev libsqlite3-dev tk-dev libgdbm-dev libc6-dev libbz2-dev
ARG PYTHON_VERSION=2.7.11
RUN wget https://www.python.org/ftp/python/${PYTHON_VERSION}/Python-${PYTHON_VERSION}.tgz
RUN tar -xvf Python-${PYTHON_VERSION}.tgz && cd Python-${PYTHON_VERSION} && ./configure && make && make install && checkinstall

# redirect all STDOUT to /dev/null
RUN apt-get install -y python-setuptools python-dev
RUN apt-get install -y python-pip 
RUN apt-get install -y curl
RUN which python && which pip

# Build from source (alternative)
RUN git clone https://github.com/juj/emsdk.git
RUN cd ./emsdk && ./emsdk install --build=Release sdk-incoming-64bit binaryen-master-64bit
RUN cd ./emsdk && ./emsdk activate --build=Release sdk-incoming-64bit binaryen-master-64bit
RUN cd ./emsdk && ./emsdk activate latest
RUN cd ./emsdk && bash ./emsdk_env.sh --build=Release

# Executable: /emsdk/emscripten/incoming/emcc
# RUN echo 'export PATH="/emsdk/emscripten/incoming/emcc:$PATH";' >> ~/.bashrc && . ~/.bashrc
# RUN echo 'export PATH="/emsdk/emscripten/incoming/emrun:$PATH";' >> ~/.bashrc && . ~/.bashrc

# Install Node.js
RUN apt-get install --yes curl
# RUN curl --silent --location https://deb.nodesource.com/setup_4.x | bash -
RUN curl -sL https://deb.nodesource.com/setup_6.x | bash -
# RUN add-apt-repository -y ppa:chris-lea/node.js
RUN apt-get install -y nodejs
# https://yarnpkg.com/en/docs/install
RUN npm install -g yarn

# Alternative approach to change $PATH
ENV PATH "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/emsdk/emscripten/incoming"

# RUN git clone https://github.com/juj/emsdk.git
# RUN cd ./emsdk && ./emsdk install latest
# RUN cd ./emsdk && ./emsdk activate latest
# RUN cd ./emsdk && bash ./emsdk_env.sh --build=Release
# Executable: /emsdk/emscripten/1.37.22/emcc
# RUN echo 'PATH="/emsdk/emscripten/1.37.22/emcc:$PATH";' >> ~/.bashrc && . ~/.bashrc
# RUN echo 'PATH="/emsdk/emscripten/1.37.22/emrun:$PATH";' >> ~/.bashrc && . ~/.bashrc

RUN mkdir -p /code/apps/hello /code/apps/hello2 /code/apps/question /code/apps/quiz /code/apps/quiz2
RUN mkdir -p /code/apps/wasm-playground/dist
COPY ./apps/hello/hello.c /code/apps/hello 
COPY ./apps/hello2/hello2.c /code/apps/hello2 
COPY ./apps/question/question.c /code/apps/question
COPY ./apps/quiz/quiz.c /code/apps/quiz 
COPY ./apps/quiz2/quiz2.c /code/apps/quiz2 
# Note: C file input and HTML file output must be in same directory 
# FIXME - When fix $PATH then change to just `emcc` and `emrun`
# RUN emcc /code/apps/hello/hello.c -s WASM=1 -o /code/apps/hello/hello.html
# RUN emcc /code/apps/question/question.c -s WASM=1 -o /code/apps/question/question.html
# RUN emcc /code/apps/quiz/quiz.c -s WASM=1 -o /code/apps/quiz/quiz.html
# Note: Must specifiy hostname of 0.0.0.0 or use container IP address (see README.md)
# RUN emrun --no_browser --no_emrun_detect --hostname=0.0.0.0 --port 8080 .

ADD . /code
WORKDIR /code