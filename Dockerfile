FROM ubuntu:lunar as build
LABEL maintainer="Jens Frey <jens.frey@coffeecrew.org>" Version="2023-06-18"

ARG DEBIAN_FRONTEND=noninteractive
COPY apt-fast.conf /etc/apt-fast.conf

RUN apt-get update \
    && apt-get -y upgrade \
    && apt-get -y install curl wget python3 python3-pip aria2 \ 
     # && \
     # Install apt-fast
     #/bin/bash -c "$(curl -sL https://git.io/vokNn)" && \
     # Find fastest mirrors and add them to apt-fast
     #python3 -m pip install -U pip apt-smart && \
     #echo "MIRRORS=(' $(apt-smart -l | tr '\n' ',') ')" >> /etc/apt-fast.conf && \
     # We have apt-fast now you can replace this with apt-get if apt-fast breaks
     #apt-fast install -y \
     graphviz \
     imagemagick \
     make \
     git \
     plantuml \
     latexmk \
     lmodern \
     texlive-full \
     wget \
     qpdf \
     openjdk-17-jdk-headless \
     pandoc \
     && apt-get autoremove \
     && apt-get clean \
     && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN apt-get -y update && \ 
     apt-get -y install \
     python3-sphinx-rtd-theme \
     python3-sphinxcontrib.plantuml \
     python3-sphinxcontrib.nwdiag \
     python3-sphinxcontrib.actdiag \
     python3-sphinxcontrib.blockdiag \
     python3-sphinxcontrib.seqdiag \
     python3-sphinxcontrib-mermaid \
     python3-sphinxcontrib.bibtex 


RUN python3 -m pip install --break-system-packages -U pip && \
     python3 -m pip install --break-system-packages recommonmark \
     autopep8 \
     bibulous \
     sphinxcontrib-textstyle \
     pybtex \
     pybtex-apa-style \
     sphinxcontrib-tikz \
     sphinxcontrib-excel-table \
     sphinxcontrib-excel-table-plus \
     sphinxcontrib-exceltable \
     sphinxcontrib-confluencebuilder \
     sphinxcontrib-versioning \
     sphinx-revealjs \
     sphinxjp.themes.revealjs \
     hovercraft \
     libsass \
     pysass \
     deck2pdf \
     rst2pdf \
     Pillow \
     pelican \
     blinker \
     cssmin \
     ddt \
     docutils \
     doc8 \
     rstcheck \
     feedgenerator \
     gitdb2 \
     GitPython \
     smartypants \
     smmap2 \
     soupsieve \
     pelican-gist \
     typogrify \
     markdown \
     pelican-neighbors \
     pelican-sitemap \
     pelican-jinja-filters \
     pelican-seo \
     beautifulsoup4 \
     pelican-plugin-linkbacks \
     pelican-feed-filter \
     pelican-simple-footnotes \
     pelican-more-categories \
     pelican-jupyter \
     hieroglyph \
     jupyter-book \
     jupyterbook-latex \
     diagrams \
     tabulate \
     pandas \
     dask \
     pyarrow \
     seaborn \
     git+https://github.com/sphinx-doc/sphinx@v7.0.0

# Overwrite with newest plantuml version
WORKDIR /usr/share/plantuml/
RUN rm -rf plantuml.jar && \
     wget "https://sourceforge.net/projects/plantuml/files/plantuml.jar" --no-check-certificate && \
     mkdir /usr/local/plantuml/ && ln -sf /usr/share/plantuml/plantuml.jar /usr/local/plantuml/plantuml.jar

FROM scratch

COPY --from=build / /
WORKDIR /docs
CMD ["make", "latexpdf"]
