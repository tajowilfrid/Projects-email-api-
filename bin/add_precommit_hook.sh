#!/bin/bash
script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
cp $script_dir/pre-commit $script_dir/../.git/hooks/pre-commit
