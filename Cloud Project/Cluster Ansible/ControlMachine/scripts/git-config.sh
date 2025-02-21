#!/bin/bash
# Git Configuration Script

# Set your name and email address
GIT_USER_NAME="Teodora Miteva"
GIT_USER_EMAIL="t.miteva@stg-bf.be"

echo "Set up global configurations ..."

# User name and e-mail configuration
git config --global user.name "$GIT_USER_NAME"
git config --global user.email "$GIT_USER_EMAIL"

# Set a preferred text editor
git config --global core.editor "nano"  

# Activate colours
git config --global color.ui auto


echo "Git configuration is completed successfuly!"

