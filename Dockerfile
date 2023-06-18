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
     python3-full \
     python3-sphinx-rtd-theme \
     python3-sphinxcontrib.plantuml \
     python3-sphinxcontrib.nwdiag \
     python3-sphinxcontrib.actdiag \
     python3-sphinxcontrib.blockdiag \
     python3-sphinxcontrib.seqdiag \
     python3-sphinxcontrib-mermaid \
     python3-sphinxcontrib.bibtex \
     python3-libsass \
     python3-rcssmin \
     python3-arrow \
     python3-autopep8 \
     python3-feedgenerator \
     python3-pybtex \
     python3-doc8 \
     python3-geopandas \
     python3-pandas \
     python3-dask \
     python3-dask-sphinx-theme \
     python3-sphinx \
     python3-docutils \ 
     python3-sphinx-rst-builder \
     python3-ddt \ 
     python3-blinker \
     python3-willow \
     python3-rstcheck \
     python3-jupyter* \
     python3-seaborn \
     python3-markdown2 \
     python3-typogrify \
     python3-diagrams \
     python3-tabulate \
     python3-typeshed \
     python3-smmap \
     python3-recommonmark \
     python3-soupsieve \
     python3-smartypants \
     pelican \
     hovercraft \
     pysassc \
     rst2pdf \ 
     rstcheck \
     tikzit \
     qtikz \
     pipx

RUN python3 -m pip install --break-system-packages --user \
     hieroglyph \
     bibulous \
     sphinx-revealjs \
     sphinxjp.themes.revealjs \
     deck2pdf \
     gitdb2 \
     jupyter-book \
     jupyterbook-latex \
     GitPython \
     pelican-gist \
     pelican-neighbors \
     pelican-sitemap \
     pelican-jinja-filters \
     pelican-seo \
     pelican-plugin-linkbacks \
     pelican-feed-filter \
     pelican-simple-footnotes \
     pelican-more-categories \
     pelican-jupyter \
     sphinxcontrib-textstyle \
     pybtex-apa-style \
     sphinxcontrib-tikz \
     sphinxcontrib-excel-table \
     sphinxcontrib-excel-table-plus \
     sphinxcontrib-exceltable \
     sphinxcontrib-confluencebuilder \
     sphinxcontrib-versioning 

# Overwrite with newest plantuml version
WORKDIR /usr/share/plantuml/
RUN rm -rf plantuml.jar && \
     wget "https://sourceforge.net/projects/plantuml/files/plantuml.jar" --no-check-certificate && \
     mkdir -p /usr/local/plantuml/ && ln -sf /usr/share/plantuml/plantuml.jar /usr/local/plantuml/plantuml.jar

FROM scratch

COPY --from=build / /
WORKDIR /docs
CMD ["make", "latexpdf"]
