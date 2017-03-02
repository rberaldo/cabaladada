#!/usr/bin/env bash
rsync -vzcrSLhp --exclude="deploy.sh" --chown=rberaldo:www-data ./_site/ pecorino:cabaladada.org

# The options:
# v - verbose
# z - compress data
# c - checksum, use checksum to find file differences
# r - recursive
# S - handle sparse files efficiently
# L - follow links to copy actual files
# h - show numbers in human-readable format
# p - keep local file permissions (not necessarily recommended)
# --exclude - Exclude files from being uploaded
