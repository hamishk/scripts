#!/bin/bash

for f in "$@"; do
	 [[ "$f" != *.flac ]] && continue # check that file isn't flac, then dependent upon confirming, skip to next iteration of loop
	 # SED details: http://tldp.org/LDP/abs/html/x23170.html
	 # Pattern matching details: http://wiki.bash-hackers.org/syntax/pattern

	
	album="$(metaflac --show-tag=album "$f" | sed 's/[^=]*=//')"
    # sed command 's/[^=]*=//'
	# s/XXX/YYY/ = substitute intances of XXX with YYY
	# [^=] match anything that's not an equals symbol,
	# *= match anything before an equals sign
	# // subsitute content with nothing (ie delete)
	album="$(metaflac --show-tag=album "$f" | sed 's/[^=]*=//')"
    artist="$(metaflac --show-tag=artist "$f" | sed 's/[^=]*=//')"
    date="$(metaflac --show-tag=date "$f" | sed 's/[^=]*=//')"
    title="$(metaflac --show-tag=title "$f" | sed 's/[^=]*=//')"
    year="$(metaflac --show-tag=date "$f" | sed 's/[^=]*=//')"
    genre="$(metaflac --show-tag=genre "$f" | sed 's/[^=]*=//')"
    tracknumber="$(metaflac --show-tag=tracknumber "$f" | sed 's/[^=]*=//')"

    flac --decode --stdout "$f" | lame --preset extreme --add-id3v2 --tt "$title" --ta "$artist" --tl "$album" --ty "$year" --tn "$tracknumber" --tg "$genre" - "${f%.flac}.mp3"
    # decode file, pipe output into lame encoder, save filename as filename minus ".flac", add '.mp3
    # outputs in same directory as flac file


    # to use: find ~/Music/ -name '*.flac' -exec ~/bin/flac2mp3.sh {} \;
    # or ~bin/flac2mp3.sh foo.flac
    # or: find ~/Music/ -name '*.flac' -print0 | xargs -0 ~/bin/flac2mp3.sh
 done