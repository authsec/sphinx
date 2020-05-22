FROM python:3.8
LABEL maintainer="Jens Frey <jens.frey@coffeecrew.org>"

ARG DEBIAN_FRONTEND=noninteractive
COPY apt-fast.conf /etc/apt-fast.conf

RUN apt-get update && apt-get -y install aria2 && \
     # Install apt-fast
     /bin/bash -c "$(curl -sL https://git.io/vokNn)" && \
     # Find fastest mirrors and add them to apt-fast
     python3 -m pip install -U pip apt-smart && \
     echo "MIRRORS=(' $(apt-smart -l | tr '\n' ',') ')" >> /etc/apt-fast.conf && \
     # We have apt-fast now you can replace this with apt-get if apt-fast breaks
     apt-fast install -y \
     graphviz \
     imagemagick \
     make \
     git \
     plantuml \
     latexmk \
     lmodern \
     texlive-full \
     wget \
     && apt-get autoremove \
     && apt-get clean \
     && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN python3 -m pip install -U pip
RUN python3 -m pip install recommonmark sphinxcontrib-textstyle \
     sphinx_rtd_theme \
     sphinxcontrib-blockdiag \
     sphinxcontrib-actdiag \
     sphinxcontrib-nwdiag \
     sphinxcontrib-seqdiag \
     sphinxcontrib-plantuml \
     sphinxcontrib-bibtex \
     sphinx-revealjs \
     sphinxjp.themes.revealjs \
     Pillow \
     git+https://github.com/sphinx-doc/sphinx

# Overwrite with newest plantuml version
WORKDIR /usr/share/plantuml/
RUN rm -rf plantuml.jar && \
     wget "https://sourceforge.net/projects/plantuml/files/plantuml.jar" --no-check-certificate && \
     mkdir /usr/local/plantuml/ && ln -sf /usr/share/plantuml/plantuml.jar /usr/local/plantuml/plantuml.jar

WORKDIR /docs
CMD ["make", "latexpdf"]
