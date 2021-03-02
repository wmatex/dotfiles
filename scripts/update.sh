#!/bin/bash

git ls-tree -r $(git branch --show-current) --name-only | xargs -I '{}' rsync --exclude /README.md --exclude /LICENSE.md -aR --from0 "$HOME/./{}" .
