FROM python:3.9

RUN apt-get update && \
  apt-get install -y --no-install-recommends \
    tzdata g++ git curl autoconf automake libtool && \
  apt-get install -y python3-setuptools && \
  apt-get install -y default-jdk default-jre && \
  rm -rf /var/lib/apt/lists/*

# Install mecab-ko manually with system config.guess/config.sub for ARM64 support.
# The bundled config.guess (from 2011) does not recognise aarch64.
# Instead of downloading from GNU Savannah (which may redirect to HTML),
# we copy the versions shipped by the automake package.
RUN curl -Lo mecab-ko.tar.gz https://bitbucket.org/eunjeon/mecab-ko/downloads/mecab-0.996-ko-0.9.2.tar.gz && \
  tar xzf mecab-ko.tar.gz && \
  cd mecab-0.996-ko-0.9.2 && \
  cp /usr/share/misc/config.guess . && \
  cp /usr/share/misc/config.sub . && \
  ./configure --enable-utf8-only && \
  make && make install && \
  ldconfig && \
  cd .. && rm -rf mecab-ko.tar.gz mecab-0.996-ko-0.9.2

# Install mecab-ko-dic
RUN curl -Lo mecab-ko-dic.tar.gz https://bitbucket.org/eunjeon/mecab-ko-dic/downloads/mecab-ko-dic-2.1.1-20180720.tar.gz && \
  tar xzf mecab-ko-dic.tar.gz && \
  cd mecab-ko-dic-2.1.1-20180720 && \
  cp /usr/share/misc/config.guess . && \
  cp /usr/share/misc/config.sub . && \
  ./autogen.sh && \
  ./configure && \
  make && make install && \
  cd .. && rm -rf mecab-ko-dic.tar.gz mecab-ko-dic-2.1.1-20180720

WORKDIR /app

COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt && \
  pip install --no-cache-dir \
    nltk==3.6.7 \
    konlpy==0.6.0 \
    mecab-ko==1.0.0 \
    mecab-python==1.0.0 \
    python-mecab-ko==1.0.14 \
    g2pk==0.9.4

ENV LANG=C.UTF-8
ENV LANGUAGE=C.UTF-8

COPY . .
