#!/bin/sh
# AoC 2k25, day 1 in classical Bourne shell.
# Question statement:
# The safe has a dial with only an arrow on it; around the dial
# are the numbers 0 through 99 in order.
# [...]
# A rotation starts with an L or R which indicates whether the
# rotation should be to the left (toward lower numbers) or to
# the right (toward higher numbers).
# [...]
# So, if the dial were pointing at 11, a rotation of R8 would
# cause the dial to point at 19. After that, a rotation of L19
# would cause it to point at 0.
# [...]
# Because the dial is a circle, turning the dial left from 0 one
# click makes it point at 99. Similarly, turning the dial right
# from 99 one click makes it point at 0.
# [...]
# The dial starts by pointing at 50.
#
# You could follow the instructions, but your recent required
# official North Pole secret entrance security training seminar
# taught you that the safe is actually a decoy. The actual
# password is the number of times the dial is left pointing at
# 0 after any rotation in the sequence.

input="$1"
shift
mod_arithmetic() {
	initial="$1"
	threshold="$2"
	current_point="$3"
	expression="$4"

	r=`expr $initial + \( \( $current_point + $expression \) $res % $threshold \)`
	if [ $r -lt "$initial" ]; then
		current_point=`expr "$r" + "$threshold"`
		r=`mod_arithmetic "$initial" "$threshold" "$current_point" 0`
	fi
	printf '%d' "$r"
}

initial_point=50
while read l; do
	num=`echo $l | tr -d 'LR'`
	case "$l" in
		L*) click="-$num";;
		R*) click="$num";;
	esac
	result=`mod_arithmetic 0 100 $initial_point "$click"`
	echo $result
	initial_point=$result
	if [ $result -eq 0 ]; then
		echo Upa!
	fi
	unset num pos click
done < "$input"
