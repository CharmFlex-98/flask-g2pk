FROM python:3.9

RUN apt-get update && \
  apt-get install -y --no-install-recommends tzdata g++ git curl && \
  apt-get install -y python3-setuptools && \
  apt-get install -y default-jdk default-jre

# Install mecab system library FIRST so python-mecab-ko can find mecab-config
RUN curl -s https://raw.githubusercontent.com/konlpy/konlpy/master/scripts/mecab.sh | bash -s

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
