#! /bin/zsh

alias ll='ls -lha'
alias ugh='echo "breathe in, breathe out"'

# for working on codespaces-jetbrains on local mac with Java 16 installed
JAVA_HOME="$(/usr/libexec/java_home -v 16)" && export JAVA_HOME

# for working on codespaces-vscode extension locally
CODESPACES_IS_LOCAL_BUILD=true