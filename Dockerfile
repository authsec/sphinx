FROM ubuntu:latest

ENV DEBIAN_FRONTEND noninteractive
ENV LIBRARY_PATH=/lib:/usr/lib

# Update apt-get sources AND install stuff
RUN apt-get update && apt-get install -y -q texlive texlive-latex-extra \
    texlive-lang-cjk python-pip make latexmk \
    openjdk-8-jre graphviz wget plantuml && \
    apt-get clean
RUN pip install --upgrade pip Sphinx recommonmark sphinxcontrib-textstyle \
    sphinx_rtd_theme \
    sphinxcontrib-blockdiag \
    sphinxcontrib-actdiag \
    sphinxcontrib-nwdiag \
    sphinxcontrib-seqdiag \
    sphinxcontrib-plantuml

# Overwrite with newest plantuml version
WORKDIR /usr/share/plantuml/
RUN rm -rf plantuml.jar && \
    wget "https://sourceforge.net/projects/plantuml/files/plantuml.jar" --no-check-certificate && \
    mkdir /usr/local/plantuml/ && ln -sf /usr/share/plantuml/plantuml.jar /usr/local/plantuml/plantuml.jar

WORKDIR /documents
VOLUME /documents

CMD ["/bin/bash"]
