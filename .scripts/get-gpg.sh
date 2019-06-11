#!/bin/sh
eval $(op signin my)
op get item "Private PGP" | jq -r '.details.sections[0].fields[0].v' | sed 's/.$//' | xclip -selection clipboard
