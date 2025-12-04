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
abs() {
	num="$1"
	if [ $num -lt 0 ]; then
		printf '( %d * -1 )\n' "$1" | bc
	else
		printf '%d' "$num"
	fi
}

ceil() {
	# Treat the input as an integer
	# because sh(1)'s test is dumb.
	i=`printf '%.2f' $1`
	iint=`printf '%s' "$i" | cut -d. -f1`
	if [ $iint -lt 0  ] || [ "`printf '%s' "$i"`" \= "`printf '%.2f' $iint`" ]; then
		printf '%d' $iint
	else
		expr $iint + 1
	fi
}

count() {
	n=$1
	c=${2:-0}
	while [ $c -ne $n ]; do
		c=`expr $c + 1`
		echo $c
	done
}

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

current_point=50
while read l; do
	num=`echo $l | tr -d 'LR'`
	case "$l" in
		L*) click="-$num";;
		R*) click="$num";;
	esac
	prev_current_point=$current_point
	result=`mod_arithmetic 0 100 $current_point "$click"`
	echo $result
	current_point=$result

	if [ $click -lt 0 ]; then
		delta="$prev_current_point - $num"
	else
		delta="$num - $prev_current_point"
	fi
	times_around_the_dial=`expr \( $delta \) / 100`
	times_around_the_dial=`abs $times_around_the_dial`
	if [ `expr \( $delta \) % 100` -ne $result ] \
		&& [ $prev_current_point -gt 0 ] && [ $prev_current_point -lt 100 ] \
		&& [ $result -ne 0 ]; then
		times_around_the_dial=`expr $times_around_the_dial + 1`
	fi

	if [ $result -eq 0 ] && [ "${times_around_the_dial:-0}" -eq 0 ]; then
		echo Upa!
	fi

	if [ "${times_around_the_dial:-0}" -ne 0 ]; then
		[ $result -eq 0 ] && times_around_the_dial=`expr $times_around_the_dial + 1`
		printf 'Upa! De novo!%.0s\n' `count $times_around_the_dial`
	fi

	unset num pos click result click_and_pcp times_around_the_dial
done < "$input"
