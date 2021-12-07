venv()
{
    # Usage:
    #
    #    venv: Creates a venv with the current `python` version.
    #    venv VERSION: Create a venv with given version.
    #
    # Example:
    #
    #    venv 3.10
    deactivate 2>/dev/null
    if ! [[ -d .venv ]]
    then
        python$1 -m venv --prompt "$(basename "$PWD"))(py$(python$1 --version | cut -d' ' -f2)" .venv
    fi
    source .venv/bin/activate
}

compile-python()
{
    # Inspired from the great https://gitlab.com/python-devs/ci-images/
    # Thanks Barry Warsaw.

    # Needs:
    # sudo apt-get update; sudo apt-get install make build-essential libssl-dev zlib1g-dev \
    # libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm \
    # libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev

    local PY_VERSION="$1"
    local BETA="$2"
    local FLAGS=""
    if dpkg --compare-versions "$PY_VERSION" ge 3.8.0  # Since 3.8.0 debug builds are ABI compatible, let's use them.
    then
        FLAGS="--with-pydebug"
    fi
    local URL="https://www.python.org/ftp/python"
    (
        cd /tmp
        wget -qO- $URL/$PY_VERSION/Python-$PY_VERSION$BETA.tgz | tar -xzf - || (
            echo "Version not found, check on $URL."
        )
        [ -d Python-$PY_VERSION$BETA ] && (cd Python-$PY_VERSION$BETA; ./configure $FLAGS --prefix=$HOME/.local/ && make -j $(nproc) && make altinstall) &&
            rm -r Python-$PY_VERSION$BETA
    )
}

compile-pythons()
{
    # Compiles a usefull set of Python versions.
    compile-python 3.5.10 &
    compile-python 3.6.15 &
    compile-python 3.7.12 &
    compile-python 3.8.12 &
    compile-python 3.9.9 &
    compile-python 3.10.1 &
    compile-python 3.11.0 a2 &
    wait
}

_compile_python()
{
    COMPREPLY=( $( compgen -W '$( command curl -s https://www.python.org/ftp/python/  | grep -o ">[0-9.]\+/<" | sed "s/^>//;s|/<$||" )' -- "${COMP_WORDS[COMP_CWORD]}") )
}
complete -F _compile_python compile-python

PATH="$PATH:$HOME/.local/bin"
