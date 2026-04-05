FROM python:3.9

RUN apt-get update && \
  apt-get install -y --no-install-recommends tzdata g++ git curl autoconf automake && \
  apt-get install -y python3-setuptools && \
  apt-get install -y default-jdk default-jre

# Install mecab-ko manually with updated config.guess/config.sub for ARM64
RUN curl -Lo mecab-ko.tar.gz https://bitbucket.org/eunjeon/mecab-ko/downloads/mecab-0.996-ko-0.9.2.tar.gz && \
  tar xzf mecab-ko.tar.gz && \
  cd mecab-0.996-ko-0.9.2 && \
  curl -o config.guess 'https://git.savannah.gnu.org/cgit/config.git/plain/config.guess' && \
  curl -o config.sub 'https://git.savannah.gnu.org/cgit/config.git/plain/config.sub' && \
  ./configure --enable-utf8-only && \
  make && make install && \
  ldconfig && \
  cd .. && rm -rf mecab-ko.tar.gz mecab-0.996-ko-0.9.2

# Install mecab-ko-dic
RUN curl -Lo mecab-ko-dic.tar.gz https://bitbucket.org/eunjeon/mecab-ko-dic/downloads/mecab-ko-dic-2.1.1-20180720.tar.gz && \
  tar xzf mecab-ko-dic.tar.gz && \
  cd mecab-ko-dic-2.1.1-20180720 && \
  ./autogen.sh && \
  ./configure && \
  make && make install && \
  cd .. && rm -rf mecab-ko-dic.tar.gz mecab-ko-dic-2.1.1-20180720

RUN mkdir app

WORKDIR /app

COPY requirements.txt .

RUN pip install -r requirements.txt

RUN pip install nltk==3.6.7
RUN pip install konlpy==0.6.0
RUN pip install mecab-ko==1.0.0
RUN pip install mecab-python==1.0.0
RUN pip install python-mecab-ko==1.0.14
RUN pip install g2pk==0.9.4

ENV LANG=C.UTF-8
ENV LANGUAGE=C.UTF-8

COPY . .
