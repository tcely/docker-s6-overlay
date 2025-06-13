#!/bin/bash
# find '".' path in README.md and replace it with '"https://github.com/socheatsok78/docker-chrony/raw/main/.'
mkdir -p dockerhub
sed 's/\.\//https:\/\/github.com\/socheatsok78\/docker-s6-overlay\/raw\/main\//g' README.md > dockerhub/README.md
