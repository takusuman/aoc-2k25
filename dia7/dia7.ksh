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
		for ((c=0; c<${#l}; c++)); do
			T[nl][c]="${l:$c:1}"
			case "${T[nl][c]}" in
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

function find_in_coordinates_list {
	nameref coordes=$1
	m="$2"
	n="$3"
	for ((i=0; i <${#coordes[@]}; i++)); do
		if (( ${coordes[$i][0]} == $m )) && (( ${coordes[$i][1]} == $n )); then
			return 0
		fi
	done
	return 1
}

function print_matrix {
	nameref M=$1
	for ((m=0; m < ${#M[@]}; m++)); do
		for ((n=0; n < ${#M[m][@]}; n++)); do
			printf '%c' "${M[m][n]}"
		done
		printf '\n'
	done
	echo ''
}

print_matrix T

for ((m=0; m < ${#T[@]}; m++)); do
	for ((n=0; n < ${#T[m][@]}; n++)); do
		case "${T[m][n]}" in
			'S') T[(m + 1)][n]='|' ;;
			'^')
			case "${T[(m - 1)][n]}" in
				'|')
				for ((m2=m; m2 < ${#T[@]}; m2++)); do
					if [[ ${T[m2][(n - 1)]} == '.' ]]; then
						T[m2][(n - 1)]='|'
					fi
					if [[ ${T[m2][(n + 1)]} == '.' ]]; then
						T[m2][(n + 1)]='|'
					fi
				done ;;
				*) continue ;;
			esac ;;
		esac
	done
done
#! find_in_coordinates_list SplintersPos $m2 $n
print_matrix T
