#!/bin/ksh93
# AoC 2k25, day 7 in KornShell 93.
# Question statement: "You thank the cephalopods
# for the help and exit the trash compactor,
# finding yourself in the familiar halls of a
# North Pole research wing.
# [...]
# Suddenly, you find yourself in an unfamiliar
# room! [...] the only way out is the teleporter.
# Unfortunately, the teleporter seems to be
# leaking magic smoke
# [...]
# After connecting one of the diagnostic tools,
# it helpfully displays error code '0H-N0',
# which apparently means that there's an issue
# with one of the tachyon manifolds.
# [...]
# A tachyon beam enters the manifold at the
# location marked S; tachyon beams always move
# downward. Tachyon beams pass freely through
# empty space ('.'). However, if a tachyon beam
# encounters a splitter ('^'), the beam is
# stopped; instead, a new tachyon beam continues
# from the immediate left and from the immediate
# right of the splitter.

input="$1"
splinters=0
for ((nl=0; ;nl++)); do
	if read l; then
		T[nl]="$l"
		for ((c=0; c<${#T[nl]}; c++)); do
			case "${T[nl]:$c:1}" in
				'S') Spos=($nl $c) ;;
			       '^') SplintersPos[$splinters]=($nl $c)
				       ((splinters+= 1)) ;;
			'.') continue ;;
		esac
		done
	else
		break
	fi
done <"$input"
unset l

print -v Spos SplintersPos T
