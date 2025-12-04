#!/bin/sh
# AoC 2k25, day 1 in classical Bourne shell.
# Question statement:
# [...] you're actually supposed to count the number of times any
# click causes the dial to point at 0, regardless of whether it
# happens during a rotation or at the end of one.
#
# [...] the dial points at zero a few extra times during its rotations:
#
# The dial starts by pointing at 50.
# The dial is rotated L68 to point at 82; during this rotation, it points at 0 once.
# The dial is rotated L30 to point at 52.
# The dial is rotated R48 to point at 0.
# The dial is rotated L5 to point at 95.
# The dial is rotated R60 to point at 55; during this rotation, it points at 0 once.
# The dial is rotated L55 to point at 0.
# The dial is rotated L1 to point at 99.
# The dial is rotated L99 to point at 0.
# The dial is rotated R14 to point at 14.
# The dial is rotated L82 to point at 32; during this rotation, it points at 0 once.
# In this example, the dial points at 0 three times at the end
# of a rotation, plus three more times during a rotation. So, in
# this example, the new password would be 6.
#
# Be careful: if the dial were pointing at 50, a single rotation
# like R1000 would cause the dial to point at 0 ten times before
# returning back to 50!

input="$1"
shift

count() {
	n=$1
	c=${2:-0}
	while [ $c -lt $n ]; do
		c=`expr $c + 1`
		printf '%d\n' $c
	done
}

current_point=50
exec 5<&0 <"$input"
while read l; do
	num=`echo $l | tr -d 'LR'`
	case "$l" in
		L*) click="-$num";;
		R*) click="$num";;
	esac
	printf '%d\n' $click
	mod_click=`expr \( $click % 100 \)`
	times_around_the_dial=`expr ${times_around_the_dial:-0} + \( $num / 100 \)`
	current_point=`expr \( $current_point + $mod_click \)`
	if [ $current_point -ge 100 ] || \
		([ $current_point -lt 0 ] && [ $current_point -ne $mod_click ]) || \
		[ $current_point -eq 0 ]; then
		times_around_the_dial=`expr $times_around_the_dial + 1`
	fi
	current_point=`expr \( $current_point + 100 \)`
	current_point=`expr \( $current_point % 100 \)`
done
exec <&5 5<&-
printf 'Upa!%.0s\n' `count $times_around_the_dial`
