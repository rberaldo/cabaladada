#!/usr/bin/env bash
rsync -vzcrSLhp --exclude="deploy.sh" ./_site/ pecorino:cabaladada.org
