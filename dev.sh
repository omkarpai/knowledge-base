#!/bin/bash

git submodule update --remote --merge
## -D switch includes Draft content 
## -F switch includes Future content
hugo server -D -F --disableFastRender