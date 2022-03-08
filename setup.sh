#!/bin/bash

# print each statement as it is executed, to aid debugging
set -x
# immediately exit if any command has non-zero exit
set -e
# if any command in a pipeline fails, use that return code instead of that of the last command
set -o pipefail

# Codespaces happens to run this script from the directory in which the script is located,
# but better not to assume that will always be so; let's get the script's directory,
# and ensure it's is not a relative path that will break a source/include below.
DIR="$(dirname "${BASH_SOURCE[0]}")"
DIR="$(cd $DIR 2> /dev/null && pwd -P)"

# idempotent symlink function, to enable error-free re-running of this script when dotfiles change
function lnk() {
  (
    if test -L "$2"; then
        unlink "$2"
    fi
    if test -f "$2"; then
        mv "$2" "$2-$(date +%s)"
    fi
    ln -s "$1" "$2"
  )
}

# git
git config --global include.path "${DIR}/git/config"
lnk ${DIR}/git/.gitignore ~/.gitignore

# vim
lnk ${DIR}/vim  ~/.vim
lnk ${DIR}/vim/.vimrc ~/.vimrc

# shell - source rather than symlink; if there's a pre-existing .*rc, add rather than overwrite
grep "\. ${DIR}/bash/.bashrc" ~/.bashrc || echo ". ${DIR}/bash/.bashrc" >> ~/.bashrc
grep "\. ${DIR}/zsh/.zshrc" ~/.zshrc || echo ". ${DIR}/zsh/.zshrc" >> ~/.zshrc

case "$OSTYPE" in
    darwin*)
        echo "doing macos-specific setup..."
        brew install gh git git-lfs the_silver_searcher vim watch
    ;;
    linux*)
        echo "doing linux-specific setup..."
    ;;
esac

if [[ -n $CODESPACES ]]
then
    echo "doing codespaces-specific setup..."
fi
