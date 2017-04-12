FROM ubuntu:latest

ENV DEBIAN_FRONTEND noninteractive

ENV LIBRARY_PATH=/lib:/usr/lib

# Update apt-get sources AND install stuff
RUN apt-get update && apt-get install -y -q texlive texlive-latex-extra texlive-lang-cjk python-pip make latexmk \
                      openjdk-8-jre graphviz wget plantuml
RUN pip install --upgrade pip
RUN pip install Sphinx
RUN pip install recommonmark
RUN pip install sphinxcontrib-textstyle
RUN pip install sphinx_rtd_theme
RUN pip install -U sphinxcontrib-blockdiag \
    sphinxcontrib-actdiag \
    sphinxcontrib-nwdiag \
    sphinxcontrib-seqdiag \
    sphinxcontrib-plantuml

WORKDIR /documents
VOLUME /documents

CMD ["/bin/bash"]
