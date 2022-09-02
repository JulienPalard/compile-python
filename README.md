# Compile Python

This is a small bash script to compile one or multiple Python versions.

I use it on my laptop, using Debian, but it may work on other distribs.

On Debian (and Debian-based distribs) it needs the following
dependencies:

```
apt install make build-essential libssl-dev zlib1g-dev libbz2-dev \
libreadline-dev libsqlite3-dev wget curl llvm libncursesw5-dev \
xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev
```


## Installation

Clone the repo anywhere, then in your `~/.bashrc` add:

    source PATH/To/THE/REPO/compile-python.sh

And for the compiled Python to be found in your PATH:

    PATH="$PATH:$HOME/.local/bin"


## Usage

```bash
$ compile-pythons
$ python3.6 --version
Python 3.6.15
$ python3.7 --version
Python 3.7.12
$ python3.8 --version
Python 3.8.12
$ python3.9 --version
Python 3.9.9
$ python3.10 --version
Python 3.10.1
$ python3.11 --version
Python 3.11.0a2
```


## How it works

It downloads official Python sources (from
[https://www.python.org/ftp/python/](https://www.python.org/ftp/python/)),
then compiles them using `--with-pydebug` (it's a dev tool, don't use
it in production! Rely on your distrib in production!), and
`--prefix=~/.local`, and finally installs it using `make altinstall`.

Anyway it's ~67 lines of code, maybe just read it.


## Be nice with distrib' provided Python

`compile-python` only produces binaries on the form `pythonX.Y` (like
`python3.8`), so `python3` and `python` will always point to your
distrib' Python.

But beware, depending on how you setup your `PATH`, `pythonY.X` may
point to your distrib' Python, or to your manually compiled one.

On Debian, don't hesitate to `apt install python-is-python3` if you want `python`
to be `python3`.


## Functions

The file declares 3 functions:

- `compile-pythons`: To compile a set of usefull Python versions.
- `compile-python`: To compile a given Python version (has autocompletion).
- `venv`: Just a wrapper to `python -m venv` that I like to use daily.

Using a function don't force you to use the others, they are **not** related.


### `compile-pythons`

This is probably the one you're seeking, it compiles a bunch of
usefull Python verisons, typically usefull if you use
[tox](https://tox.wiki/en/latest/) and need multiple Python versions
to test your project.


### `compile-python`

This one is used by `compile-python` but you can use it manually, like:

    compile-python 3.10.1


### `venv`

A bit unrelated to the two others, here for historical reasons, this
is how I create venvs. I use it like:

```bash
$ venv
```

If the venv does not exists it's created, if it exist it's just activated.

It takes an optional parameter: the Python version to use, like `venv
3.10` or `venv 3.6`.

The venv prompt takes the name of the current directory plus the
version, like:

    (compile-python)(py3.10.0) mdk@seaph:~/ $

which I find usefull, but feel free to not use it.


## Why not using `pyenv`?

I know `pyenv` exists, I even used it back in the time. I did not
appreciated the `shims` part (I'm not saying it's bad), so I tried
myself as something more simple: just build Python and that's it.
