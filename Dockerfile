FROM ubuntu:latest

ENV DEBIAN_FRONTEND noninteractive

# Update apt-get sources AND install stuff
RUN apt-get update && apt-get install -y -q texlive texlive-latex-extra texlive-lang-cjk python-pip make latexmk pandoc
RUN pip install --upgrade pip
RUN pip install Sphinx
RUN pip install recommonmark
RUN pip install sphinxcontrib-textstyle
RUN pip install sphinx_rtd_theme

WORKDIR /documents
VOLUME /documents

CMD ["/bin/bash"]
