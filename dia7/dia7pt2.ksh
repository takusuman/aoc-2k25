#!/bin/ksh93
# AoC 2k25, day 7 pt. 2 in KornShell 93.
# Question statement: 
# Part 1:
# "You thank the cephalopods
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
# 
# Part 2:
# "With your analysis of the manifold complete,
# you begin fixing the teleporter. However, as
# you open the side of the teleporter to replace
# the broken manifold, you are surprised to
# discover that it isn't a classical tachyon
# manifold - it's a quantum tachyon manifold."
#
# In other words, your (my) work was useless!
# 
# "With a quantum tachyon manifold, only a single
# tachyon particle is sent through the manifold.
# A tachyon particle takes both the left and
# right path of each splitter encountered.
# Since this is impossible, the manual recommends
# the many-worlds interpretation of quantum
# tachyon splitting: each time a particle reaches
# a splitter, it's actually time itself which
# splits. In one timeline, the particle went
# left, and in the other timeline, the particle
# went right."
#
# taks note: compile this with shcomp.
# I think it shall be somewhat faster.

input="$1"
splinters=0
for ((nl=0; ;nl++)); do
	if read l; then
		for ((c=0; c<${#l}; c++)); do
			T[nl][c]="${l:$c:1}"
			case "${T[nl][c]}" in
				'S') Spos=($nl $c)
					continue ;;
				'^') SplintersPos[$splinters]=($nl $c)
					((splinters+= 1))
					continue ;;
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
	melem="$2"
	nelem="$3"
	for ((i=0; i <${#coordes[@]}; i++)); do
		if (( ${coordes[$i][0]:--1} == $melem )) && (( ${coordes[$i][1]:--1} == $nelem )); then
			return 0
			break
		fi
	done
	return 255
}

function print_matrix {
	nameref M=$1
	for ((i=0; i < ${#M[@]}; i++)); do
		for ((j=0; j < ${#M[i][@]}; j++)); do
			printf '%c' "${M[i][j]}"
		done
		printf '\n'
	done
	echo ''
}

print_matrix T

for ((m=0; m < ${#T[@]}; m++)); do
	for ((n=0; n < ${#T[m][@]}; n++)); do
		case "${T[m][n]}" in
			'S')
				# Now, instead of calculating the trajectory
				# of the ray as a coordinate, we calculate
				# just how many times did a ray go through a
				# column. 
				rayway[$n]=1 ;;
			'^') 	# Nullify the current column since there shall
				# not exist any ray coming directly from below
				# the splinter.
				rayway[$n]=0
				
				rayway[$((n - 1))]=1
				rayway[$((n + 2))]=1
				;;
		esac
	done
done
print -C rayway
printf 'Número de caminhos que o raio pôde percorrer até o fim: %d\n' $ways
