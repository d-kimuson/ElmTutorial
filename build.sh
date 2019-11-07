#!/bin/bash

for file in `find src -type f -name *.elm`; do
  elm make $file --output `echo $file | sed s/src/build/g | sed s/.elm/.js/g`
done
