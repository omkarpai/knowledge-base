#!/bin/bash

git submodule update --remote --merge
## -D switch inclused Draft content
hugo server -D --disableFastRender