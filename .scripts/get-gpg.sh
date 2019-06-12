#!/bin/sh
eval $(op signin my)
op get item "Private PGP" | jq -j '.details.sections[0].fields[0].v' | xclip -selection clipboard
