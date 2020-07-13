#!/bin/bash

docker run --rm -it -v "`pwd`":/host --net=host -w /host --entrypoint "/host/$1" klakegg/hugo:0.57.2
