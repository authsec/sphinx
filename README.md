# Sphinx

This Docker image contains a Sphinx documentation toolchain with support for

* Full [TeX Live](https://www.tug.org/texlive/) LaTeX installation
* [Markdown](https://daringfireball.net/projects/markdown/)
* [PlantUML](https://plantuml.com/)
* [Read the Docs Sphinx Theme](https://sphinx-rtd-theme.readthedocs.io/en/stable/)
* [BibTeX](http://www.bibtex.org/) support
* [reveal.js](https://revealjs.com/) support
* [Hovercraft!](https://hovercraft.readthedocs.io/en/latest/usage.html) support
* [Pelican](https://docs.getpelican.com/en/stable/index.html) with Markdown support

# Build Docker Image

In order for all of this to work, you need to have Docker installed. You can [get it here](https://www.docker.com/products/docker-desktop).

You do not need to do this, but if you want to build the image yourself, you can do so with the following command.

``` bash
$#> docker build -t authsec/sphinx .
```

# Sphinx 

Use the following commands to interact with the sphinx container. The commands below show the raw `docker` command. You can however alias the command for convenience.

You can for example set an alias like this in your shell environment:

``` bash
$#> alias asphinx='docker run --rm -it -v $(pwd):/docs authsec/sphinx'
```

This will basically allow you to replace the long `docker run --rm -it -v $(pwd):/docs authsec/sphinx` command with the command or "alias" `asphinx`.

## Sphinx on Windows

If you want to use this container on Windows, you need to slightly tweak the command line to read:

``` bash
$#> docker run --rm -it -v ${PWD}:/docs authsec/sphinx
```

## Create a new Sphinx document

If you want an interactive experience:

``` bash
$#> mkdir mydoc
$#> cd mydoc
$#> docker run --rm -it -v $(pwd):/docs authsec/sphinx sphinx-quickstart 
```

You you have used the `alias` command above, the `docker` command will look like:

``` bash
$#> asphinx sphinx-quickstart
```

Create a new document e.g. like so:

``` bash
$#> mkdir mydoc
$#> cd mydoc
$#> docker run --rm -it -v $(pwd):/docs authsec/sphinx sphinx-quickstart --sep -p "My Demo" -a "Siegfried Sphinx" -v "0.0.1" -r "0.0.1" -l "en" --suffix .rst --epub --master index --ext-intersphinx --ext-todo --makefile -m
```

## Compile a Sphinx document

You can generate your Sphinx document by executing the following command in the directory you created your document (in the above example `mydoc`).

The `clean` argument is not really necessary but might help in certain circumstanes, you could also just run `... make html`.

``` bash
$#> docker run --rm -it -v $(pwd):/docs authsec/sphinx make clean html
```

# Pelican Blog

You can create a new Pelican based blog with the `pelican-quickstart` command using it like:

``` bash
$#> docker run --rm -it -v $(pwd):/docs authsec/sphinx pelican-quickstart
```

If you want to preview your blog with the built in webserver on http://localhost:8000, use the following command:

``` bash
$#> docker run --rm -it -v $(pwd):/docs -p8000:8000 authsec/sphinx pelican -e BIND=0.0.0.0 --autoreload --listen
```

For further information see the [official documentation](https://docs.getpelican.com/en/stable/index.html).

## Using pelican themes

In order to use pelican themes, you have to make them accessible to the container runtime. I suggest mapping the path to `/pelican-themes` inside the container. That way you can configure the theme like `THEME="/pelican-themes/mnmlist"` for example.

You can find a lot of pelican themes [on Github](https://github.com/getpelican/pelican-themes)

I order to keep things separate, I'd suggest setting up, or cloning, the themes at the same level as your blog.

Say you created your blog in a folder called `tmp` you want to clone the themes repository into the `tmp` folder too, so it looks like:

```
tmp
├── blog
└── pelican-themes
```

You can clone the themes by executing the below command inside the `tmp` folder:

``` bash
$#> git clone --recursive https://github.com/getpelican/pelican-themes ./pelican-themes
```

The following command must be executed inside your `blog` folder. It will mount the `pelican-themes` folder into the container under `/pelican-themes` where you can reference it in your config.

``` bash
$#> docker run --rm -it -v $(pwd):/docs -v $(pwd)/../pelican-themes:/pelican-themes  -p8000:8000 authsec/sphinx pelican -e BIND=0.0.0.0 --autoreload --listen
```

# SASS Compiler

This is especially useful if you're planning to utilize CSS in your presentation. You can generate a CSS from a SCSS source file. You can learn all about that at the [Sass: Sass Basics](https://sass-lang.com/guide) site.

The image contains `pysassc` which is a SASS compiler, and the `pysass` wrapper ([pysass · PyPI](https://pypi.org/project/pysass/)) which allows you to watch the SASS files for changes and compile them automatically when they change.

# Hovercraft Presentations

You can find a description of all the bells and whistles of  `hovercraft` where it says [Hovercraft! - Merging convenience and cool!](https://hovercraft.readthedocs.io/en/latest/index.html)

## Compiling a hovercraft document

If you don't want to install all the tooling required to compile a hovercraft presentation, you can use the command below:

``` bash
$#> docker run --rm -it -v $(pwd):/docs authsec/sphinx hovercraft yourinput.rst output
```

## Using the built in web server

If you want to access your presentation through the web server built into `hovercraft`, you also need to expose or publish the port with the `docker` command.

You can run the server using the following command:

``` bash
$#> docker run --rm -it -p8000:8000 -v $(pwd):/docs authsec/sphinx hovercraft positions.rst
```

You can then access your presentation through a web browser by navigating to [localhost:8000](http://localhost:8000/).

# reveal.js Presentations

There seem to be multiple reveal.js implementations available at this point in time. I picked up on two of them.

A fairly new implementation of reveal.js presentations with Sphinx where a good starting point is probably the Github repository [attakei/sphinx-revealjs: Sphinx builder to revealjs presentations](https://github.com/attakei/sphinx-revealjs).

And one that is around for quite a bit but does not seem to be maintained any longer? which can be found in this Github repository [tell-k/sphinxjp.themes.revealjs: A sphinx theme for generate reveal.js presentation. #sphinxjp](https://github.com/tell-k/sphinxjp.themes.revealjs)

## Compiling a reveal.js presentation

Since there are two (or even more implementations) available at the moment I listed the two styles I know about below.

### >>> "attakei" style implementation

You can compile these presentations with:

``` bash
$#> docker run --rm -it -v $(pwd):/docs authsec/sphinx make revealjs
```

### >>> "tell-k" style implementation

You can compile these presentations with:

``` bash
$#> docker run --rm -it -v $(pwd):/docs authsec/sphinx make html
```

as you would compile any ordinary Sphinx document.

# Cleaning Up

If you're doing doing your documentation thing, you can clean up your system by executing:

```bash
$#> docker system prune -a
```