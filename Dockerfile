FROM python:3.11

MAINTAINER Part Time Larry "parttimelarry@gmail.com"

ADD . /app

WORKDIR /app

RUN apt-get update && apt-get install -y build-essential redis-server sqlite3 \
    curl software-properties-common

# install nodejs and wscat websocket client
RUN apt-get install -y ca-certificates curl gnupg
RUN curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg
RUN echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_20.x nodistro main" | tee /etc/apt/sources.list.d/nodesource.list
RUN apt-get install nodejs -y
RUN apt-get install npm -y
RUN npm install wscat

# download and build TA-Lib
RUN wget http://prdownloads.sourceforge.net/ta-lib/ta-lib-0.4.0-src.tar.gz && \
  tar -xvzf ta-lib-0.4.0-src.tar.gz && \
  cd ta-lib/ && \
  ./configure --prefix=/usr && \
  make && \
  make install

RUN rm -R ta-lib ta-lib-0.4.0-src.tar.gz

# install popular Python packages
RUN pip3 install -r requirements.txt