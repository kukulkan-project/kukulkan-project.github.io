#!/bin/bash
cd edu
for filename in [a-z]*.md; do
    claat export $filename
done
