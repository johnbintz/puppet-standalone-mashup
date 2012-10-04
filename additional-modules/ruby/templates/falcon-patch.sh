#!/bin/bash

curl https://raw.github.com/gist/2593385/perf_and_gc.diff | patch -p1
if [ $? -ne 0 ]; then exit 1; fi

curl https://raw.github.com/gist/2502451/46c9fbc07abf7ea5670ba0e23a11ff93d6e3c9db/yaml.rb.diff | patch -p1
if [ $? -ne 0 ]; then exit 1; fi

touch patched

